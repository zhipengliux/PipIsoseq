#!/usr/bin/bash

st=`date`

array=( "$@" )
#usage
if [ ! -n "$1" ]
then
	echo "                  cDNA_CupCake pipeline                                                    "
	echo " Usage : `basename $0`                                                             "
	echo " Required:                                                                               "
	echo "   --fasta [pacbio hq cluster full-length non-chemica reads]                             "
	echo "   --sam   [alignment for genome with GMAP or minimap2 (must be sorted)]                 "
	echo "   --csv   [file of *cluster_report.csv]                                                 "
	echo "   --outputprefix                                                                        "
	echo " Optional:                                                                               "
	echo "   --max_5_diff [default:1000]                                                               "
	echo "   --max_3_diff [default:100]                                                               "
	echo "   --nomono [filter out mono exon]                                                          "
	echo " Example: bash `basename $0` --fasta JJ27_Tes.ccs.flnc.clustered.hq.fasta"
	echo "                             --sam JJ27_Tes.ccs.flnc.clustered.hq.fasta.ssc_ucsc_ens.sorted.sam"
	echo "                             --csv JJ27_Tes.ccs.flnc.clustered.cluster_report.csv"
	echo "                             --outputprefix JJ27_Tes"
	echo " Output: outputprefix.collapsed.gff, outputprefix.collapsed.rep.fq, outputprefix.collapsed.group.txt"
	echo "         outputprefix.collapsed.read_stat.txt, outputprefix.collapsed.abundance.txt"
	echo "*********************************************************************************************"
	exit 1
fi

#get parameters
fasta="unassigned"
sam="unassigned"
diff5=1000
diff3=100
outputprefix="unassigned"
csv="unassigned"
nomono=0

echo "`basename $0`"
echo ">>>Starting the pipeline to collapse redundant reads"
for arg in "$@"
do
	if [[ $arg == "--fasta" ]]
	then
		fasta=${array[$counter+1]}
		echo 'input fasta:'$fasta
	elif [[ $arg == "--sam" ]]
	then
		sam=${array[$counter+1]}
		echo 'input sorted sam:'$sam
	elif [[ $arg == "--max_5_diff" ]]
	then
		diff5=${array[$counter+1]}
		echo '5 difference:'$diff5
	elif [[ $arg == "--max_3_diff" ]]
	then
		diff3=${array[$counter+1]}
		echo '3 difference:'$diff3
	elif [[ $arg == "--outputprefix" ]]
	then
		outputprefix=${array[$counter+1]}
		echo 'prefix:'$outputprefix
	elif [[ $arg == "--csv" ]]
	then
		csv=${array[$counter+1]}
		echo 'cluster_report.csv:'$csv
	elif [[ $arg == "--nomono" ]]
	then
		nomono=1
		echo 'start up filter out mono exon'
	fi
	let counter=$counter+1
done

#Check data
if [ $fasta == "unassigned" ];then
	echo "	 >>> [Error]: No fasta input"
else
	fastat=1
fi

if [ $sam == "unassigned" ];then
	echo "	 >>> [Error]: No sorted sam input"
else
	samstat=1
fi

if [ $outputprefix == "unassigned" ];then
	echo "	 >>> [Error]: Please set OutputPrefix"
else
	prefixstat=1
fi

if [ $csv == "unassigned" ];then
	echo "	 >>> [Error]: Please input cluster_report.csv file"
else
	csvstat=1
fi

if [[ $fastat == "1" && $samstat == "1" && $prefixstat == "1" && $csvstat == "1" ]]
then
	echo "	 Status check: pass"
else
	echo "	 Status check: failed, stop the pipeline"
	exit 1
fi

collapse_isoforms_by_sam.py --input $fasta \
	-s $sam \
	--max_5_diff $diff5 \
	--max_3_diff $diff3 \
	--dun-merge-5-shorter \
	-o $outputprefix \
	1>${outputprefix}.collapse.std.log \
	2>${outputprefix}.collapse.err.log && \
	get_abundance_post_collapse.py ${outputprefix}.collapsed $csv 1>${outputprefix}.collapse.std1.log 2>${outputprefix}.collapse.err1.log && \
	filter_away_subset.py ${outputprefix}.collapsed

if [[ $nomono == "1" ]]
then
	echo "Remove monoexon isoforms"
	if [[ -e ${outputprefix}.collapsed.filtered.rep.fa ]];then
		python /home/data/vip6t05/soft/cDNA_Cupcake/sequence/fa2fq.py ${outputprefix}.collapsed.filtered.rep.fa && \
			rename ${outputprefix}.collapsed.filtered.rep.fastq ${outputprefix}.collapsed.filtered.rep.fq && \
			python /home/data/vip6t05/soft/cDNA_Cupcake/cupcake/tofu/filter_monoexon.py ${outputprefix}.collapsed.filtered
	elif [[ -e ${outputprefix}.collapsed.filtered.rep.fq ]];then
		python /home/data/vip6t05/soft/cDNA_Cupcake/cupcake/tofu/filter_monoexon.py ${outputprefix}.collapsed.filtered
	elif [[ -e ${outputprefix}.collapsed.filtered.rep.fastq ]];then
		rename ${outputprefix}.collapsed.filtered.rep.fastq ${outputprefix}.collapsed.filtered.rep.fq && \
			python /home/data/vip6t05/soft/cDNA_Cupcake/cupcake/tofu/filter_monoexon.py ${outputprefix}.collapsed.filtered
	else
		echo 'filter out mono exon wrong : '
		echo 'make sure the fasta/fastq file are exist'
	fi
elif [[ $nomono == "0" ]];then
	echo "Don't remove monoexon isoforms"
fi
ed=`date`
echo "Started time: "$st
echo "Ended time: "$ed
