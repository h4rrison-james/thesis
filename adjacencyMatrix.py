# Used to manually classify entities as either 'symptom' or 'condition' by setting the 'isSymptom' field accordingly

import os
import math
import MySQLdb as mdb, sys # MySQL Support Libraries
from py2neo import neo4j, cypher # Neo4j Graph Database
from urlparse import urlparse
import numpy as np
from tempfile import TemporaryFile
np.set_printoptions(threshold='nan')

#### Main execution function ####
if __name__ == '__main__':
	
	# Connect to the Neo4j graph database
	graph_db = neo4j.GraphDatabaseService('http://localhost:7474/db/data')
	
	# Connect to the MySQL Database
	primary = None
	try:	
		primary = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
		
	except mdb.Error, e:
	    print "Error %d: %s" % (e.args[0], e.args[1])
	    sys.exit(1)
	
	with primary:
		
		# Obtain a reference to the Symptom index
		symptoms = graph_db.get_or_create_index(neo4j.Node, "Symptoms")
		
		# Define the array
		x = []
		
		#Look through all symptoms
		for i in range(1, 1050):
			query = "START n=node(%d), m=node(*) WITH n, m MATCH n-[q?]-m WITH m.name as m, n, count(q) as links ORDER BY m RETURN distinct n,n.name, collect(links) as row ORDER BY n.name" % i
			data, metadata = cypher.execute(graph_db, query)
			name = data[0][1]
			matrix_row = data[0][2]
			if len(x) == 0:
				x = np.array(matrix_row)
				print 'Adding row ' + str(i)
			else:
				print 'Adding row ' + str(i)
				matrix_row = np.array(matrix_row)
				x = np.vstack((x, matrix_row))

	# Save the array as a file after building
	np.savetxt('am.txt', x)

	# Tidy up database connections
	primary.close();
