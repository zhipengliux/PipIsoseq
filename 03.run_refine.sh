#!/bin/bash
#Usage
if [ ! -n "$3" ]
then
	echo "	Part 3: refine reads"
	echo "	Usage: bash `basename $0` [*.ccs.fl.*Clontech_3p.bam] [primer.fa] [threads]"
	echo "	Example: bash `basename $0` JJ27_Tes.ccs.fl.*Clontech_3p.bam primer.fasta 2"
	echo "	Output: full-length non-concatemer reads [*.ccs.fl.NEB_5p--NEB_Clontech_3p.flnc.bam or Clontech_5p]"
else
	data=$1
	primer=$2
	threads=$3
	echo "`basename $0`"
	echo ">>Starting the pipeline to refine reads"
	echo "	Input data: "$data
	prefix=`ls $data|sed 's/.bam//'`
	st=`date`
	isoseq refine $data $primer ${prefix}.flnc.bam --require-polya --num-threads $threads
	ed=`date`
	echo "	Output data: "${prefix}.flnc.bam
	bn=`samtools view $data |grep -v "^@"|wc -l`
	echo "**Statistical**"
	echo "Before refining: "$bn
	an=`samtools view ${prefix}.flnc.bam|grep -v "^@"|wc -l`
	echo "After refining: "$an
	echo "Started time: "$st
	echo "Ended time: "$ed
	echo "Done running `basename $0`"
	echo "**********************************************************************************"
fi
