#!/bin/bash

if [ ! -n "$1" ]
then
	#Usage
	echo "	Part 2: remove 5/3 primer "
	echo "	Usage: bash `basename $0` ccs.bam"
	echo "	Example: bash `basename $0` JJ27_Tes.ccs.bam"
	echo "	Output: full-length reads [OutputPrefix.ccs.fl.NEB_5p--NEB_Clontech_3p.bam or Clontech_5p]"
else
	data=$1
	echo "`basename $0`"
	echo ">>Starting the pipeline to remove 3p and 5p primers using lima"
	echo "	Input data: "$data
	prefix=`ls $data|sed 's/.bam//'`
	/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/lima $data ~/pacbio/mytest/primer.fasta ${prefix}.fl.bam --isoseq --peek-guess
	if [[ -s ${prefix}.fl.lima.summary ]]
	then
		out=`ls *3p.bam`
		echo "	Output data: "$out
		echo "	**Summary:"
		cat ${prefix}.fl.lima.summary|head -3
		echo "Done running `basename $0`"
		echo "**********************************************************************************"
	else
		echo "Wrong!!! please check input data"
	fi
fi
