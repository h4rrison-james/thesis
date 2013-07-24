# Author: Harrison Sweeney <harrison dot j dot sweeney at gmail dot com>
# License: Simplified BSD
# Description: Searches through the 'Related Symptoms' field and attempts to make links with other symptoms in the table.

import MySQLdb as mdb, sys, os # MySQL Support Libraries
from sklearn import svm, metrics
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import BernoulliNB, MultinomialNB
from sklearn.tree import DecisionTreeClassifier

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
		for sample in rows:
			descriptions.append(sample[2])
			targets.append(sample[5])

		# Tidy up database connections
		curp.close();
		primary.close();
		
		return (descriptions, targets)

#### Main execution function ####
if __name__ == '__main__':
	# Retreive the data from the MySQL database
	result = import_data()
	corpus = result[0]
	target = result[1]
	
	# Vectorize using 'bag of words' and format data
	vectorizer = TfidfVectorizer(min_df=1)
	X = vectorizer.fit_transform(corpus)
	print "n_samples: %d, n_features: %d" % X.shape
	n_samples = len(target)
	data = X.toarray()
	
	# Create the classifiers
	classifiers = [DecisionTreeClassifier(random_state=0), MultinomialNB(alpha=.01), BernoulliNB(alpha=.01)]
	
	for csf in classifiers:
		# Train the classifier
		n_train = 800
		csf.fit(data[:n_train], target[:n_train])

		# Now predict the outcome using the classifier
		expected = target[n_train:]
		predicted = csf.predict(data[n_train:])

		print "="*80
		print "Classification report for classifier %s:\n\n%s" % (
		    csf, metrics.classification_report(expected, predicted))
		#print "Confusion matrix:\n%s\n" % metrics.confusion_matrix(expected, predicted)
		