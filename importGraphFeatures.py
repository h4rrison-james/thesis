# Used to manually classify entities as either 'symptom' or 'condition' by setting the 'isSymptom' field accordingly

import os
import math
import MySQLdb as mdb, sys # MySQL Support Libraries
from py2neo import neo4j, cypher # Neo4j Graph Database
from urlparse import urlparse

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
	
		# Retrieve all the rows in the symptom table
		cur = primary.cursor()
		cur.execute("SELECT * FROM symptoms")
		
		# Get all rows of the result set
		rows = cur.fetchall()
		
		#Look through all symptoms
		for symptom in rows:
			node = symptoms.get("symptom_id", str(symptom[0]))[0] # Find the node corresponding to the symptom
			query = "START n=node(%d) WITH n, length(n-->()) as outdegree, length(n<--()) as indegree RETURN indegree, outdegree" % node.id
			data, metadata = cypher.execute(graph_db, query)
			indegree = data[0][0]
			outdegree = data[0][1]
			print "Indegree: %d, Outdegree: %d" % (indegree, outdegree)
			
			query = "UPDATE `symptoms` SET `Indegree` = '" + str(indegree) + "', `Outdegree` = '" + str(outdegree) + "' WHERE `symptoms`.`id` = '" + str(symptom[0]) + "'"
			cur.execute(query)

	# Tidy up database connections
	primary.close();
