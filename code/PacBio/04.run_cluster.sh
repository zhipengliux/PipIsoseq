#!/bin/bash
#pipeline 4
if [ ! -n "$2" ]
then
	#Usage
	echo "	Part 4: clustering reads"
	echo "	Single flnc.bam file or list all flnc.bam to flnc.fnfo"
	echo "	Usage: bash `basename $0` <flnc.bam|flnc.fnfo> <OutputPrefix>"
	echo "	Example: bash `basename $0` JJ27_Tes.ccs.fl.*Clonetech_3p.flnc.bam JJ27_Tes"
	echo "	Output: clustered reads [OutputPrefix.ccs.flnc.clustered.bam]"
else
	#Processing
	data=$1
	prefix=$2
	echo "`basename $0`"
	echo ">>Starting the pipeline to cluster reads"
	echo "	Input data: "$data
	echo "	OutPrefix: "$prefix
	st=`date`
	/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/isoseq3 cluster $data ${prefix}.ccs.flnc.clustered.bam --use-qvs --num-threads 2
	gunzip ${prefix}.ccs.flnc.clustered.hq.fasta.gz
	gunzip ${prefix}.ccs.flnc.clustered.lq.fasta.gz
	ed=`date`
	bn=`/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/samtools view $data|grep -v "^@"|wc -l`
	an=`/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/samtools view ${prefix}.ccs.flnc.clustered.bam|grep -v "^@"|wc -l`
	echo "**Statistical**"
	echo "Before cluster: "$bn
	echo "After cluster: "$an
	echo "Start time: "$st
	echo "End time: "$ed
	echo "Done running `basename $0`"
	echo "**********************************************************************************"
fi
