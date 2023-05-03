#!/usr/bin/bash
#run_gmap.sh
##version 2018-07-04
source /home/data/vip6t05/miniconda3/bin/activate gmap
array=( "$@" )
#usage
if [ ! -n "$1" ]
then
	echo "******************************************************************"
	echo "*                  gmap                                          *"
	echo "* Usage : `basename $0`                                            *"
	echo "*   -i   [input data for hq.fasta]                               *"
	echo "*   -t   [number of threads to calculation,default=10]           *"
	echo "*   -n   [1-5,alignment path,default=1]                          *"
	echo "*   -d   [ssc_ens107db,ssc_ucscdb,default: ssc_ens107db]         *"
	echo "******************************************************************"
	exit 1
fi

#get parameters
db="ssc_ens107db"
npath=1
cpu=10

for arg in "$@"
do
	if [[ $arg == "-i" ]]
	then
		fasta=${array[$counter+1]}
		echo 'input hq.fasta:'$fasta
	elif [[ $arg == "-t" ]]
	then
		cpu=${array[$counter+1]}
		echo 'cpu:'$cpu
	elif [[ $arg == "-d" ]]
	then
		db=${array[$counter+1]}
		echo 'genome:'$db
	elif [[ $arg == "-n" ]]
	then
		npath=${array[$counter+1]}
		echo 'alignment path:'$npath
	fi
	let counter=$counter+1
done

gmap.sse42 \
	-d $db \
	-t $cpu \
	-A \
	-f samse \
	-n $npath \
	$fasta \
	1>${fasta}.${db}.sam \
	2>${fasta}.${db}.log && \
	/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/samtools view -b ${fasta}.${db}.sam -o ${fasta}.${db}.bam && \
	/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/samtools sort ${fasta}.${db}.bam -o ${fasta}.${db}.sorted.bam && \
	/home/data/vip6t05/soft/smrtlink/smrtcmds/bin/samtools index ${fasta}.${db}.sorted.bam && \
	rm -f ${fasta}.${db}.sam && \
	echo "gmap finished"



