#!/bin/bash
st=`date`
source /home/data/vip6t05/miniconda3/bin/activate sqanti3
export PYTHONPATH=$PYTHONPATH:/home/data/vip6t05/soft/cDNA_Cupcake/sequence/
export PYTHONPATH=$PYTHONPATH:/home/data/vip6t05/soft/cDNA_Cupcake/

if [ ! -n "$3" ]
then
	echo "                           **SQANTI3 QC**                             "
	echo "  Usage: bash `basename $0` <unannotated.gff/gtf> <db_name> <outputprefix>"
	echo "          <db_name> may set 'ssc_ens107db' or 'ssc_ucsc_ens', related to GMAP db"
	echo "  Example: bash `basename $0` JJ27_Tes.collapsed.filtered.gff ssc_ens107db SQANTI3_JJ27_Tes"
	echo "  The result will be put in SQANTI3_JJ27_Tes directory."
else
	gff=$1
	db=$2
	outprefix=$3
	mkdir -p $outprefix
	outputdir=`readlink -f $outprefix`
	echo ">> Starting SQANTI3 QC"
	echo "  Input data: "$gff
	echo "  Using db: "$db
	echo "  Output dir: "$outputdir
	if [ $db == "ssc_ens107db" ]
	then
		echo "	Using ensembl107 database"
		python /home/data/vip6t05/soft/SQANTI3/sqanti3_qc.py $gff \
			/home/data/vip6t05/reference/ensembl107/Sus_scrofa.Sscrofa11.1.107.gtf \
			/home/data/vip6t05/reference/ensembl107/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa \
			--polyA_motif_list /home/data/vip6t05/soft/SQANTI3/data/polyA_motifs/mouse_and_human.polyA_motif.txt \
			-o $outprefix \
			-d $outputdir \
			--cpus 10 \
			--report html \
			1>${outputdir}/std.log \
			2>${outputdir}/err.log
		echo "	Finished to compare with ensembl107 annotation"
		ed=`date`
		echo "Start time: "$st
		echo "End time: "$ed
	elif [ $db == "ssc_ucsc_ens" ]
	then
		echo "	Using UCSC database"
		python /home/data/vip6t05/soft/SQANTI3/sqanti3_qc.py $gff \
			/home/data/vip6t05/reference/ens_ucsc_genome/susScr11.ensGene.gtf \
			/home/data/vip6t05/reference/ens_ucsc_genome/susScr11.fa \
			--polyA_motif_list /home/data/vip6t05/soft/SQANTI3/data/polyA_motifs/mouse_and_human.polyA_motif.txt \
			-o $outprefix \
			-d $outputdir \
			--cpus 10 \
			--report html \
			1>${outputdir}/std.log \
			2>${outputdir}/err.log
		echo "	Finished to compare with UCSC database annotation"
		ed=`date`
		echo "Start time: "$st
		echo "End time: "$ed
	else
		echo "Please check your database is support"
	fi
fi
