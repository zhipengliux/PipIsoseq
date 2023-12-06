#!/bin/bash

if [ ! -n "$3" ]
then
	#Usage
	echo "	Part 2: remove 5/3 primer "
	echo "	Usage: bash `basename $0` [*.ccs.bam] [primer.fa] [threads]"
	echo "	Example: bash `basename $0` JJ27_Tes.ccs.bam primer.fasta 2"
	echo "	Output: full-length reads [*.ccs.fl.NEB_5p--NEB_Clontech_3p.bam or Clontech_5p]"
else
	data=$1
	primer=$2
	threads=$3
	echo "`basename $0`"
	echo ">>Starting the pipeline to remove 3p and 5p primers using lima"
	echo "	Input data: "$data
	prefix=`ls $data|sed 's/.bam//'`
	st=`date`
	lima $data $primer ${prefix}.fl.bam --isoseq --peek-guess -j $threads
	ed=`date`
	if [[ -s ${prefix}.fl.lima.summary ]]
	then
		out=`ls *3p.bam`
		echo "	Output data: "$out
		echo "	**Summary:"
		cat ${prefix}.fl.lima.summary|head -3
		echo "Started time: "$st
		echo "Ended time: "$ed
		echo "Done running `basename $0`"
		echo "**********************************************************************************"
	else
		echo "No summary file found, please check your input data and output files"
	fi
fi
