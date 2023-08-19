# Software prerequisites

This pipeline is designed to run on Linux servers and requires the following software.

``` sh
# Use conda install
SMRT-LINK #https://www.pacb.com/support/software-downloads
gmap 
cDNA_Cupcake
SQANTI3
```
# Software installation

``` sh
# install SMRT LINK
wget -c https://downloads.pacbcloud.com/public/software/installers/smrtlink_12.0.0.177059.zip
unzip smrtlink_12.0.0.177059.zip
./smrtlink_12.0.0.177059.run --rootdir /your_dir/smrtlink/smrtlink --no-extract
# Add SMRT LINK to the $PATH
export PATH=/your_dir/smrtlink/smrtcmds/bin:$PATH
# install SQANTI3
git clone https://github.com/ConesaLab/SQANTI3.git
cd SQANTI3
mv SQANTI3.conda_env.yml pippacbio.yml
source activate pippacbio
cd .
## install cDNA_Cupcake
git clone https://github.com/Magdoll/cDNA_Cupcake.git
cd cDNA_Cupcake
python setup.py build
python setup.py install
export PYTHONPATH=$PYTHONPATH:<path_to>/cDNA_Cupcake/sequence/
export PYTHONPATH=$PYTHONPATH:<path_to>/cDNA_Cupcake/
cd .
## install gmap
conda install gmap
```
# Pipeline setup

``` sh
wget -c https://ftp.ensembl.org/pub/release-110/fasta/sus_scrofa/dna/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa.gz
# build genome index
gmap_build -d ssc_ensdb Sus_scrofa.Sscrofa11.1.dna.toplevel.fa.gz
```
# Usage

``` sh
git clone git@github.com:zhipengliu92/PipIsoseq.git
source activate pippacbio
# example
bash 01.run_ccs.sh m64082_200109_050254.subreads.4--4.bam JJ27GW 3 0.9
bash 02.run_lima.sh JJ27GW.ccs.bam
bash 03.run_refine.sh JJ27GW.ccs.fl.*Clontech_3p.bam
bash 04.run_cluster.sh JJ27GW.ccs.fl.*Clontech_3p.flnc.bam JJ27GW
bash 05.run_gmap.sh JJ27GW.ccs.flnc.clustered.hq.fasta ssc_ens107db
bash 06.run_cDNA_Cupcake.sh --fasta JJ27GW.ccs.flnc.clustered.hq.fasta --sam JJ27GW.ccs.flnc.clustered.hq.fasta.ssc_ens107db.sorted.sam --csv JJ27GW.ccs.flnc.clustered.cluster_report.csv --outputprefix JJ27GW
bash 07.run_sqanti3_qc.sh JJ27GW.collapsed.filtered.gff ssc_ens107db SQANTI3_JJ27_Tes
```

