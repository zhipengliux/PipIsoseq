# Software prerequisites

This pipeline is designed to run on Linux servers and requires the following software.

``` sh
# Use conda install
SMRT-LINK #https://www.pacb.com/support/software-downloads
gmap 
cDNA_Cupcake
SQANTI3
```

``` sh
# Add SMRT LINK to the $PATH
export PATH=/HomeDir/smrtlink/smrtcmds/bin:$PATH

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
cd .
## install gmap
conda install gmap

```

# Long- and short-read RNA sequencing from five reproductive organs of boar

