# Searches through the 'Related Symptoms' field and attempts to make links with other symptoms in the table.

import os
import MySQLdb as mdb, sys # MySQL Support Libraries
from urlparse import urlparse

# Connect to the MySQL Database
primary, secondary, tertiary = None, None, None
try:	
	primary = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
	secondary = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
	tertiary = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
	
except mdb.Error, e:
    print "Error %d: %s" % (e.args[0], e.args[1])
    sys.exit(1)

def clear_related_table():
	curp = primary.cursor()
	curp.execute("DROP TABLE IF EXISTS related_symptoms")
	curp.execute("CREATE TABLE IF NOT EXISTS related_symptoms(id INT PRIMARY KEY AUTO_INCREMENT, `Related Symptom` VARCHAR(50), `Primary Symptom Id` INT)")
	curp.execute("ALTER TABLE related_symptoms ADD CONSTRAINT tb_un UNIQUE (`Related Symptom`)")
	primary.commit()
	curp.close()

def analyse_symptoms():
	
	# Retrieve the first 10 rows in the symptom table
	curp = primary.cursor()
	curp.execute("SELECT * FROM symptoms LIMIT 10")
	
	for result in curp.fetchall():
		# For each symptom in the table, look through related symptoms
		print '\nAnalysing Symptom \'' + result[1] + '\''
		for related_symptom in result[4].split(' , '):
			# For each related symptom, look through the original symptom list
			curs = secondary.cursor()
			curs.execute("SELECT * FROM symptoms")
			for primary_symptom in curs.fetchall():
				# Check if the primary symptom and the related symptom refer to the same symptom
				if similar(related_symptom, primary_symptom[1]):
					print 'Match found: ' + related_symptom + '-> (' + str(primary_symptom[0]) + ') ' + primary_symptom[1]
					curt = tertiary.cursor()
					# Insert an entry into the related symptoms table for each identified relation
					curt.execute("INSERT INTO related_symptoms(`Related Symptom`, `Primary Symptom Id`) \
						VALUES(%s, %s)  ON DUPLICATE KEY UPDATE `Related Symptom` = `Related Symptom`", \
						(related_symptom, str(primary_symptom[0])))
					tertiary.commit() # Commit the results to the database
					
	# Tidy up database connections
	curp.close(); curs.close(); curt.close()
	primary.close(); secondary.close(); tertiary.close()
					
def similar(primary, related):
	# Perform exact name check first (case insensitive)
	if related.lower() == primary.lower():
		return True
	else:
		return False
		
def test_similarity(primary, related):
	if similar(primary, related):
		print '\'' + primary + '\' and \'' + related + '\' are related.'
	else:
		print 'No match found'

if __name__ == '__main__':
	clear_related_table()
	analyse_symptoms()

	#related = 'Abdominal pain'
	#primary = 'Abdominal Pain'
	#test_similarity(primary, related)
