#!/bin/bash
#Usage
if [ ! -n "$5" ]
then
	echo "	Part 1: generate ccs "
	echo "	We only set useful parameters, if you want to know the detail of all parameters."
	echo "	Please run below command in terminal [I suggest you do this]"
	echo "	ccs -h"
	echo "	Usage: bash `basename $0` [Subreas.bam] [OutputPrefix] [TopPasses|num|0-50] [minrq|0-1] [threads]"
	echo "	Example: bash `basename $0` Subreads.bam JJ27_Tes 3 0.9 2"
	echo "	Output: OutputPrefix.ccs.bam; OutputPrefix.ccs_report.txt"
else
	data=$1
	out=$2
	pass=$3
	rq=$4
	threads=$5
	echo "`basename $0`"
	echo ">>Starting the pipeline to generate CCS using ccs "
	echo "	Input data: "$data
	st=`date`
	if [[ -e ${data}.pbi ]]
	then
		ccs $data ${out}.ccs.bam --top-passes $pass --min-rq $rq --num-threads $threads --report-file ${out}.ccs_report.txt
	else
		echo "Index lost:"$data
		echo "Generating index"
		pbindex $data && \
			echo "Index generated" && \
			ccs $data ${out}.ccs.bam --top-passes $pass --min-rq $rq --num-threads $threads --report-file ${out}.ccs_report.txt
	fi
	ed=`date`
	if [[ -s ${out}.ccs_report.txt ]]
	then
		echo "  **Summary:"
		cat ${out}.ccs_report.txt|head -3
		echo "Started time: "$st
		echo "Ended time: "$ed
		echo "Done running `basename $0`"
		echo "**********************************************************************************"
	else
		echo "No report file found. Please check your input data and output files..."
	fi
fi

