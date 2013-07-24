# Builds the relational graph database in Neo4j

import os
import MySQLdb as mdb, sys # MySQL Support Libraries
from py2neo import neo4j, cypher # Neo4j Graph Database
from urlparse import urlparse

# Connect to the Neo4j graph database
graph_db = neo4j.GraphDatabaseService('http://localhost:7474/db/data')

# Connect to the MySQL Database
con = None
try:	
	primary = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
	secondary = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
	
except mdb.Error, e:
    print "Error %d: %s" % (e.args[0], e.args[1])
    sys.exit(1)

def create_graph(graph_db):

	# Clear all nodes from the database
	graph_db.clear()
	
	# Obtain a reference to the Symptom index
	symptoms = graph_db.get_or_create_index(neo4j.Node, "Symptoms")
	
	# Retrieve all the rows in the symptom table
	cur = primary.cursor()
	cur.execute("SELECT * FROM symptoms")
	
	# Loop through each of the rows, adding a new node to the database
	numrows = int(cur.rowcount)
	for i in range(numrows):
		row = cur.fetchone()
		
		# Create the parent node, checking if it is a symptom or condition
		if (row[5] == 1):
			print 'Adding Parent Symptom: "' + row[1] + '"'
			from_node, = graph_db.create({"symptom_id": row[0], "name": row[1], "type": "symptom", "description": row[2]}) # Make a node for the parent symptom
		else:
			print 'Adding Parent Condition: "' + row[1] + '"'
			from_node, = graph_db.create({"symptom_id": row[0], "name": row[1], "type": "condition", "description": row[2]}) # Make a node for the parent symptom
			
		symptoms.add("symptom_id", row[0], from_node) # Add the node to the symptoms index for easy querying later
		
	print str(numrows) + ' symptoms succesfully added.'
	
	# Tidy up
	primary.commit()
	cur.close()

def add_primary_relationships(graph_db):
	
	# Obtain a reference to the Symptom index
	symptoms = graph_db.get_or_create_index(neo4j.Node, "Symptoms")
	
	cur = primary.cursor()
	cur.execute("SELECT * FROM primary_symptoms")
	
	for row in cur.fetchall():
		from_node = symptoms.get("symptom_id", str(row[0]))[0] # Find the beginning node, taking first element from array
		to_node = symptoms.get("symptom_id", str(row[1]))[0] # Find the end node
		from_node.create_relationship_to(to_node, "type of") # Add 'type of' relation between the two nodes
		print "{0} -> {1}".format(from_node["name"], to_node["name"])
		
def add_secondary_relationships(graph_db):
	
	# Obtain a reference to the Symptom index
	symptoms = graph_db.get_or_create_index(neo4j.Node, "Symptoms")
	
	# Retrieve all rows in symptom table
	cur = primary.cursor()
	cur.execute("SELECT * FROM symptoms")
	
	# Loop through each of the rows, extracting relational data
	numrows = int(cur.rowcount)
	for i in range(numrows):
		row = cur.fetchone()
		from_node = symptoms.get("symptom_id", str(row[0]))[0] # Find the parent node, taking first element from array
		print 'Analysing Parent Node: ' + from_node["name"]
	
		related = row[4].split(' , ') # Separate the related symptoms out into a tuple
		for symptom in related:
			curs = secondary.cursor()
			curs.execute("SELECT * FROM related_symptoms WHERE `Related Symptom` = %s", (symptom)) # Check if any relations are already stored
			result = curs.fetchall()
			if result:
				for symptom_row in result:
					# Add the relation back to the different parent node, according to id
					#print symptom_row[0] + ': Match found (' + str(symptom_row[1]) + ')'
					to_node = symptoms.get("symptom_id", str(symptom_row[1]))[0] # Find the related node, taking first element from array
					from_node.create_relationship_to(to_node, "related to")
#			else:
#				# Make a new node for the symptom, and add a relation back to the parent
#				#print symptom + ': No match found, creating new node'
#				to_node, = graph_db.create({"name": symptom, "type": "related_symptom"}) # Make a node for each related symptom
#				from_node.create_relationship_to(to_node, "related to") # Add a relation back to the parent node
		
#		causes = row[3].split(' , ') # Separate the causes out into a tuple
#		for cause in causes:
#			to_node, = graph_db.create({"name": cause, "type": "cause"})
#			from_node.create_relationship_to(to_node, "caused by") # Add relation back to the parent node

if __name__ == '__main__':
    # Connect to the database
    # Run script to create the Neo4j graph data
	create_graph(graph_db)
	add_primary_relationships(graph_db)
	add_secondary_relationships(graph_db)
