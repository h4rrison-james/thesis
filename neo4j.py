import os
import MySQLdb as mdb, sys # MySQL Support Libraries
from flask import Flask # Flask Web Server
from py2neo import neo4j, cypher # Neo4j Graph Database
from urlparse import urlparse

# Connect to the Neo4j graph database
graph_db = neo4j.GraphDatabaseService('http://localhost:7474/db/data')

# Connect to the MySQL Database
con = None
try:	
	con = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
	
except mdb.Error, e:
    print "Error %d: %s" % (e.args[0], e.args[1])
    sys.exit(1)

def create_graph(graph_db):

	# Clear all nodes from the database
	graph_db.clear()
	
	# Retrieve the first 10 rows in the symptom table
	cur = con.cursor()
	cur.execute("SELECT * FROM symptoms LIMIT 10")
	
	# Loop through each of the rows, extracting relational data
	numrows = int(cur.rowcount)
	for i in range(numrows):
		row = cur.fetchone()
		from_node, = graph_db.create({"name": row[1], "type": "symptom", "description": row[2]}) # Make a node for the symptom
		
		related = row[4].split(' , ') # Separate the related symptoms out into a tuple
		for symptom in related:
			to_node, = graph_db.create({"name": symptom, "type": "symptom"}) # Make a node for each related symptom
			from_node.create_relationship_to(to_node, "related to") # Add a relation back to the parent node
		
		causes = row[3].split(' , ') # Separate the causes out into a tuple
		for cause in causes:
			to_node, = graph_db.create({"name": cause, "type": "cause"})
			from_node.create_relationship_to(to_node, "caused by") # Add relation back to the parent node
	
	# Create two nodes, one for us and one for you.
	# Make sure they both have 'name' properties with values.
	#from_node, to_node = graph_db.create({"name": "neo4j"}, {"name": "you"})

	# Create a 'loves' relationship from the 'from' node to the 'to' node
	#from_node.create_relationship_to(to_node, "loves")

def find_friends(graph_db):
    query = "START n=node(*) MATCH (n)-[r:loves]->(m) return n, r, m"
    # This is our awesome Cypher query language.
    # STARTing with all the nodes in the graph
    # MATCH the ones that have a LOVES relationship
    # and RETURN the starting node, the relationship, and the end node.
    data, metadata = cypher.execute(graph_db, query)
    return data[0]

app = Flask(__name__)
app.debug = True

@app.route('/')
def hello():
    # Query the database
    result = find_friends(graph_db)
    # Pull out the data we want from the single row of results
    return "{0} {1} {2}".format(result[0]['name'], result[1].type,  result[2]['name'] )

if __name__ == '__main__':
    # Connect to the database
    # Make sure our reference data is there
    create_graph(graph_db)
    port = int(os.environ.get('PORT', 5000))
    #app.run(host='0.0.0.0', port=port)
