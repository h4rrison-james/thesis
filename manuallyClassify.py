# Used to manually classify entities as either 'symptom' or 'condition' by setting the 'isSymptom' field accordingly

import os
import math
import MySQLdb as mdb, sys # MySQL Support Libraries
from urlparse import urlparse

#### Main execution function ####
if __name__ == '__main__':
	
	# Connect to the MySQL Database
	primary = None
	try:	
		primary = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
		
	except mdb.Error, e:
	    print "Error %d: %s" % (e.args[0], e.args[1])
	    sys.exit(1)
	
	with primary:
	
		# Retrieve the first 10 rows in the symptom table
		# Done 1000
		curp = primary.cursor()
		curp.execute("SELECT * FROM symptoms LIMIT 1000,100")
		
		# Get all rows of the result set
		rows = curp.fetchall()
		
		#Look through all related symptoms using multiprocessing to speed things up
		for symptom in rows:
			key = raw_input(symptom[1] + ' is a symptom (Y/N): ')
			if (key.lower() == 'y'):
				query = "UPDATE `symptoms` SET `isSymptom` = '1' WHERE `symptoms`.`id` = '" + str(symptom[0]) + "'"
				curp.execute(query)
			else:
				query = "UPDATE `symptoms` SET `isSymptom` = '0' WHERE `symptoms`.`id` = '" + str(symptom[0]) + "'"
				curp.execute(query)

	# Tidy up database connections
	primary.close();
