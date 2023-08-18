#!/bin/bash
#Considering splicing
if [ ! -n "$2" ]
then
	echo "	Part 5: Mapping hq/lq cluster to genome"
	echo "	Usage: bash `basename $0` [*.ccs.flnc.clustered.hq.fasta] [db_name]"
	echo "		<db_name> if no db_name, use 'gmap_build -d db_name genome.fa' to build it"
	echo "	Example: bash `basename $0` JJ27_Tes.ccs.flnc.clustered.hq.fasta ssc_ens107db"
	echo "	Output: sorted sam file [*.ccs.flnc.clustered.hq.fasta.db_name.sorted.sam]"
else
	#-n 1 will not report chimeric
	data=$1
	db=$2
	echo "`basename $0`"
	echo ">>Starting genome mapping by gmap"
	echo "	Input data: "$data
	echo "	Using db: "$db
	echo "	Only mapped reads will be reported"
	st=`date`
	gmap.sse42 -d $db -t 10 -B 5 -A -f samse --nofails -n 1 $data 1>${data}.${db}.sam 2>${data}.${db}.log && \
		sort -k 3,3 -k 4,4n ${data}.${db}.sam > ${data}.${db}.sorted.sam && \
		rm ${data}.${db}.sam
	bn=`less $data|grep ">"|wc -l`
	an=`less ${data}.${db}.sorted.sam|grep -v "^@"|wc -l`
	ed=`date`
	echo "	**Summary:"
	echo "Input reads: "$bn
	echo "Mapped reads: "$an
	echo "Start time: "$st
	echo "End time: "$ed
	echo "Done running `basename $0`"
	echo "**********************************************************************************"
fi
