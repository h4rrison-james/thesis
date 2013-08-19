# Author: Harrison Sweeney <harrison dot j dot sweeney at gmail dot com>
# License: Simplified BSD

import numpy as np
import pylab as pl
import Orange
from array import array

#### Main execution function ####
if __name__ == '__main__':

	# Build table
	data = Orange.data.Table('description_tab')
	
	bayes = Orange.classification.bayes.NaiveLearner(name="bayes")
	tree = Orange.classification.tree.SimpleTreeLearner(name="tree")
	knn = Orange.classification.knn.kNNLearner(name="knn")

	base_learners = [bayes, tree, knn]
	stack = Orange.ensemble.stacking.StackedClassificationLearner(base_learners)

	learners = [stack, bayes, tree, knn]
	res = Orange.evaluation.testing.cross_validation(learners, data, 10)
	print "\n".join(["%8s: %5.3f" % (l.name, r) for r, l in zip(Orange.evaluation.scoring.AUC(res), learners)])