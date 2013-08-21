# Author: Harrison Sweeney <harrison dot j dot sweeney at gmail dot com>
# License: Simplified BSD

import numpy as np
import pylab as pl
import Orange
from array import array

#### Main execution function ####
if __name__ == '__main__':

	# Build table
	description_data = Orange.data.Table('description_tab')
	degree_data = Orange.data.Table('degree_tab')
	am_data = Orange.data.Table('am_tab')
	
	data = Orange.data.Table([description_data, degree_data, am_data])
	
	bayes = Orange.classification.bayes.NaiveLearner(name="bayes")
	bayes_csf = bayes(description_data)
	tree = Orange.classification.tree.SimpleTreeLearner(name="tree")
	tree_csf = tree(am_data)
	svm = Orange.classification.svm.SVMLearner(name="svm")
	svm_csf = svm(degree_data)
	

	base_learners = [bayes, tree, svm]
	stack = Orange.ensemble.stacking.StackedClassificationLearner(base_learners)
	learners = [stack, bayes, tree, svm]
	res = Orange.evaluation.testing.cross_validation(learners, data, 5)
	print "\n".join(["%8s: %5.3f" % (l.name, r) for r, l in zip(Orange.evaluation.scoring.AUC(res), learners)])
	