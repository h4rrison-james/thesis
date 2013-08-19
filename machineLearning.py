# Author: Harrison Sweeney <harrison dot j dot sweeney at gmail dot com>
# License: Simplified BSD
# Description: Searches through the 'Related Symptoms' field and attempts to make links with other symptoms in the table.

import MySQLdb as mdb, sys, os # MySQL Support Libraries
import numpy as np
import pylab as pl

from sklearn import metrics, cross_validation, datasets, svm
from sklearn.feature_extraction.text import CountVectorizer, TfidfTransformer
from sklearn.naive_bayes import BernoulliNB, MultinomialNB, GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.feature_selection import SelectPercentile, f_classif, SelectKBest, chi2

def import_data():
	# Connect to the MySQL Database
		primary = None
		try:	
			primary = mdb.connect(host='127.0.0.1', port=8889, user='root', passwd='root', db='bowie_db');
			
		except mdb.Error, e:
		    print "Error %d: %s" % (e.args[0], e.args[1])
		    sys.exit(1)
		
		# Retrieve the first 10 rows in the symptom table
		curp = primary.cursor()
		curp.execute("SELECT * FROM symptoms")
		rows = curp.fetchall()
		
		descriptions = []
		targets = []
		indegrees = []
		outdegrees = []
		for sample in rows:
			descriptions.append(sample[2])
			targets.append(sample[5])
			indegrees.append(sample[6])
			outdegrees.append(sample[7])

		# Tidy up database connections
		curp.close();
		primary.close();
		
		return (descriptions, targets, indegrees, outdegrees)

def normalise_data(data):
	# Normalize the data using the tf-idf transform
	transformer = TfidfTransformer()
	tfidf = transformer.fit_transform(data)
	data = tfidf.toarray()
	return data
	
def load_adjacency_matrix():
	x = np.loadtxt('am.txt')
	return x

def run_classifiers(data, target, classifier):
	# Create the classifiers
	classifiers = [
		DecisionTreeClassifier(random_state=0), # Decision Tree
		MultinomialNB(alpha=0.01), # Naive Bayes (Multinomial)
		svm.SVC(),
		KNeighborsClassifier(3), # K-Neighbours
	]
	
	csf = classifiers[classifier]
	# Train the classifier using cross-validation
	# The 'scoring' parameter can be changed to a number of options
	scores = cross_validation.cross_val_score(csf, data, target, cv=10, scoring='f1')
	print "Classification scores  for %s:" % str(csf).split('(')[0]
	print "F1: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() / 2)

#### Main execution function ####
if __name__ == '__main__':
	# Retreive the data from the MySQL database
	result = import_data()
	corpus = result[0]
	target = np.array(result[1]) # Has to be of type np.array for cross-validation
	np.savetxt('target.txt', target)
	indegree = result[2]
	outdegree = result[3]
	
	# Count dictionary data using 'bag of words' and format data
	vectorizer = CountVectorizer(min_df=1)
	X = vectorizer.fit_transform(corpus)
	print '\n' + '='*8 + ' Raw Data ' + '='*8
	print "n_samples: %d, n_features: %d" % X.shape
	n_samples = len(target)
	data = X.toarray()
	
	# Univariate feature selection
	selector = SelectKBest(chi2, k=3000) #3000 gives highest F1
	data = selector.fit_transform(data, target)
	print '\n' + '='*8 + ' After Feature Selection ' + '='*8
	print "n_samples: %d, n_features: %d" % data.shape
	np.savetxt('description.txt', data)
	run_classifiers(data, target, 1)
	
	# Load adjacency matrix
	am = load_adjacency_matrix()
	print '\n' + '='*8 + ' Adjacency Matrix ' + '='*8
	print "n_samples: %d, n_features: %d" % am.shape
	run_classifiers(am, target, 0)
	
	# Load degree information
	degree = np.column_stack((indegree, outdegree))
	np.savetxt('degree.txt', degree)
	print '\n' + '='*8 + ' Degree Information ' + '='*8
	print "n_samples: %d, n_features: %d" % degree.shape
	run_classifiers(degree, target, 2)
	
	# Add the adjacency matrix to the data
	data = np.column_stack((data, am))
	print '\n' + '='*8 + ' Including Graph Data ' + '='*8
	print "n_samples: %d, n_features: %d" % data.shape
	run_classifiers(data, target, 1)
	
	# Normalise the data
	data = normalise_data(data)
	print '\n' + '='*8 + ' After Normalizing Data ' + '='*8
	print "n_samples: %d, n_features: %d" % data.shape
	run_classifiers(data, target, 1)
		