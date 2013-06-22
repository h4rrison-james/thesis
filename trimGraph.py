# Trims the relationships in the graph database

import os
import MySQLdb as mdb, sys # MySQL Support Libraries
from py2neo import neo4j, cypher # Neo4j Graph Database
from urlparse import urlparse

# Connect to the Neo4j graph database
graph_db = neo4j.GraphDatabaseService('http://localhost:7474/db/data')

def trim_relationships(graph_db):
	# Obtain a reference to the Symptom index
	symptoms = graph_db.get_or_create_index(neo4j.Node, "Symptoms")
	
	

if __name__ == '__main__':
    # Connect to the database
    # Run script to create the Neo4j graph data
	trim_relationships(graph_db)