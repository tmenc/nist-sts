#! /bin/sh
tail -n +5 "experiments/AlgorithmTesting/finalAnalysisReport.txt" |\
	grep -o -e '/' |\
	wc -l
