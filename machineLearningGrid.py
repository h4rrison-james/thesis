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
from sklearn.grid_search import GridSearchCV
from sklearn.cross_validation import train_test_split
from sklearn.metrics import classification_report

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
	
def run_classifiers(data, target):
	# Create the classifiers
	classifiers = [
		MultinomialNB(alpha=0.01), # Naive Bayes (Multinomial)
		svm.SVC(C=1000, kernel='rbf', gamma=1e-4), # Support Vector Machine
		DecisionTreeClassifier(max_features='auto'), # Decision Tree
		KNeighborsClassifier(n_neighbors=5, algorithm='auto'), # K-Neighbours
	]
	
	scores = ['precision', 'recall', 'f1', 'accuracy', 'roc_auc']
	
	for clf in classifiers:
		print "Classification scores  for %s:" % str(clf).split('(')[0]
		template = "{0:10}{1:>10}{2:>10}"
		for score in scores:
			# Train the classifier using cross-validation
			# The 'scoring' parameter can be changed to a number of options
			res = cross_validation.cross_val_score(clf, data, target, cv=10, scoring=score)
			print template.format(score + ':', '%0.2f' % res.mean(), '%0.2f' % (res.std() / 2))

def train_classifiers(data, target):
	# Create the classifiers
	classifiers = [
		MultinomialNB(), # Naive Bayes (Multinomial)
		svm.SVC(), # Support Vector Machine
		DecisionTreeClassifier(), # Decision Tree
		KNeighborsClassifier(), # K-Neighbours
	]
	
	scores = ['roc_auc']
	
	tuned_parameters = [
		[{'alpha': [0.01, 0.02, 0.05, 0.1, 0.5, 1]}],
		[{'kernel': ['rbf'], 'gamma': [1e-3, 1e-4], 'C': [1, 10, 100, 1000]}, {'kernel': ['linear'], 'C': [1, 10, 100, 1000]}],
		[{'max_features': ['auto', 'sqrt', 'log2', None]}],
		[{'n_neighbors': [2, 3, 5], 'algorithm': ['auto', 'ball_tree', 'kd_tree']}]
	]
	
	X_train, X_test, y_train, y_test = train_test_split(data, target, test_size=0.5, random_state=0)
	
	for i in range(len(classifiers)):
		print "Classification scores  for %s:" % str(classifiers[i]).split('(')[0]
		template = "{0:10}{1:>10}{2:>10}"
		for score in scores:
			# Train the classifier using cross-validation
			# The 'scoring' parameter can be changed to a number of options
			clf = GridSearchCV(classifiers[i], tuned_parameters[i], cv=5, scoring=score)
			clf.fit(X_train, y_train)
			print("Best parameters set found on development set:")
			print(clf.best_estimator_)
#			for params, mean_score, scores in clf.grid_scores_:
#			        print("%0.3f (+/-%0.03f) for %r"
#			              % (mean_score, scores.std() / 2, params))
#			y_true, y_pred = y_test, clf.predict(X_test)
#			print(classification_report(y_true, y_pred))

#### Main execution function ####
if __name__ == '__main__':
	# Retreive the data from the MySQL database
	result = import_data()
	corpus = result[0]
	target = np.array(result[1]) # Has to be of type np.array for cross-validation
	
	# Load f1 (Adjacency Matrix)
	f1 = load_adjacency_matrix()
	
	# Process and format f2 (Vectorized Description)
	vectorizer = CountVectorizer(min_df=1)
	X = vectorizer.fit_transform(corpus)
	n_samples = len(target)
	data = X.toarray()
	selector = SelectKBest(chi2, k=3000) #3000 gives highest F1
	f2 = selector.fit_transform(data, target)
	
	# Load f3 (Degree Data)
	indegree = result[2]
	outdegree = result[3]
	f3 = np.column_stack((indegree, outdegree))
	
	run_classifiers(f3, target)
		