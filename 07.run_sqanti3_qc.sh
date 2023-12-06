#!/bin/bash
st=`date`

if [ ! -n "$4" ]
then
	echo "                           **SQANTI3 QC**                             "
	echo "  Usage: bash `basename $0` [unannotated gff/gtf] [ref gtf] [ref genome] [outprefix]"
	echo "  Example: bash `basename $0` JJ27_Tes.collapsed.filtered.gff ssc_ens107db SQANTI3_JJ27_Tes"
	echo "  The result will be put in SQANTI3_JJ27_Tes directory."
else
	gff=$1
	rgtf=$2
	rgenome=$3
	outprefix=$4
	mkdir -p $outprefix
	outputdir=`readlink -f $outprefix`
	echo ">> Starting SQANTI3 QC"
	echo "  Input uannotated gtf/gff: "$gff
	echo "  Input reference gtf/gff: "$rgtf
	echo "  Input reference genome: "$rgenome
	echo "  Output dir: "$outputdir
	python sqanti3_qc.py $gff \
		$rgtf \
		$rgenome \
		-o $outprefix \
		-d $outputdir \
		--cpus 1 \
		--report html \
		1>${outputdir}/std.log \
		2>${outputdir}/err.log && \
		echo "	Finished to compare with annotation gtf"
	ed=`date`
	echo "Start time: "$st
	echo "End time: "$ed

