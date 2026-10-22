#!/bin/bash
#SBATCH --job-name=PCA      
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1 
#SBATCH --mem=32G
#SBATCH --time=8:00:00
#SBATCH --output=./logs/%x.%j.out
#SBATCH --error=./logs/%x.%j.err
#SBATCH --mail-type=END
#SBATCH --mail-user=Sydney.Houston@uvm.edu

cd /users/s/r/srhousto/SydHoustonEcoGenomics/PopulationGenomics/mydata

OUTDIR=/users/s/r/srhousto/SydHoustonEcoGenomics/PopulationGenomics/myresults

echo $OUTDIR

VCF=Lottia_gigantea_pl_flt3.renamed.vcf.gz

echo $VCF

module load plink

plink --vcf $VCF --double-id --allow-extra-chr \
    --set-missing-var-ids @:# \
    --indep-pairwise 50 10 0.2 \
    --out $OUTDIR/Lg_LD_0.2_alldata

plink --vcf $VCF --double-id --allow-extra-chr --set-missing-var-ids @:# \
    --extract $OUTDIR/Lg_LD_0.2_alldata.prune.in \
    --make-bed --pca --out $OUTDIR/Lg_LD_0.2_alldata