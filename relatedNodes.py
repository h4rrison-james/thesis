# Searches through the 'Related Symptoms' field and attempts to make links with other symptoms in the table.

import os
import math
import MySQLdb as mdb, sys # MySQL Support Libraries
from fuzzywuzzy import fuzz
import multiprocessing
from urlparse import urlparse

#### Clears the database table ####
def clear_related_table():
	curp = primary.cursor()
	curp.execute("DROP TABLE IF EXISTS related_symptoms")
	curp.execute("CREATE TABLE IF NOT EXISTS related_symptoms(id INT PRIMARY KEY AUTO_INCREMENT, `Related Symptom` VARCHAR(200), `Primary Symptom Id` INT)")
	#curp.execute("ALTER TABLE related_symptoms ADD CONSTRAINT tb_un UNIQUE (`Related Symptom`)")
	primary.commit()
	curp.close()

#### Makes connections to related symptoms for each row in rows ####
def analyse_symptoms(rows, secondary, tertiary):
	
	counter = 0
	
	for result in rows:
		# For each symptom in the table, look through related symptoms
		for related_symptom in result[4].split(' , '):
			# For each related symptom, look through the original symptom list
			curs = secondary.cursor()
			curs.execute("SELECT * FROM symptoms")
			for primary_symptom in curs.fetchall():
				# Check if the primary symptom and the related symptom refer to the same symptom
				if similar(related_symptom, primary_symptom[1]):
					print 'Match found: ' + related_symptom + '-> (' + str(primary_symptom[0]) + ') ' + primary_symptom[1]
					counter = counter + 1
					curt = tertiary.cursor()
					# Insert an entry into the related symptoms table for each identified relation
					curt.execute("INSERT INTO related_symptoms(`Related Symptom`, `Primary Symptom Id`) \
						VALUES(%s, %s)  ON DUPLICATE KEY UPDATE `Related Symptom` = `Related Symptom`", \
						(related_symptom, str(primary_symptom[0])))
					tertiary.commit() # Commit the results to the database
					curt.close() # Close the cursor
			curs.close() # Close the cursor
	
	# Close connections
	secondary.close(); tertiary.close()
	
	return counter
					
#### Returns true if primary and related strings are fuzzily matched ####
def similar(primary, related):
	# Convert both strings to lower case
	primary = primary.lower()
	related = related.lower()

	# This breaks each string into tokens, order them alphabetically, and returns the highest matching set of tokens.
	if (fuzz.token_set_ratio(primary, related) > 90):
		return True
	else:
		return False

#### Runs through the list of symptoms using multiprocessing ####
def multiprocess(nums, nprocs):
	def worker(nums, s_conn, t_conn, q):
		count = analyse_symptoms(nums, s_conn, t_conn)
		q.put(count)

	# Each process will get 'chunksize' nums
	q = multiprocessing.Queue()
	chunksize = int(math.ceil(len(nums) / float(nprocs)))
	procs = []

	for i in range(nprocs):
		s_conn = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
		t_conn = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
		p = multiprocessing.Process(
			target=worker,
			args=(nums[chunksize * i:chunksize * (i + 1)], s_conn, t_conn, q))
		procs.append(p)
		p.start()
	
	# Add up the total matches
	total = 0
	for i in range(nprocs):
		total = total + q.get()
			
	# Wait for all worker processes to finish
	for p in procs:
		p.join()
		
	return total

#### Used to test the similarity between two strings ####
def test_similarity(primary, related):
	if similar(primary, related):
		print '\'' + primary + '\' and \'' + related + '\' are related.'
	else:
		print 'No match found'

#### Main execution function ####
if __name__ == '__main__':
	
	# Connect to the MySQL Database
	primary = None
	try:	
		primary = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
		
	except mdb.Error, e:
	    print "Error %d: %s" % (e.args[0], e.args[1])
	    sys.exit(1)
	
	clear_related_table()
	
	# Retrieve the first 10 rows in the symptom table
	curp = primary.cursor()
	curp.execute("SELECT * FROM symptoms LIMIT 2")
	
	# Get all rows of the result set
	rows = curp.fetchall()
	total = multiprocess(rows, 8)
	print 'Total conections: ' + str(total)

	# Tidy up database connections
	curp.close();
	primary.close();
