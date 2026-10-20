#!/bin/bash
#SBATCH --job-name=vcf_stats
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=30:00:00
#SBATCH --output=./logs/%x.%j.out
#SBATCH --error=./logs/%x.%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Sydney.Houston@uvm.edu

module load gcc
module load vcftools

INDIR="/gpfs1/home/s/r/srhousto/SydHoustonEcoGenomics/PopulationGenomics/mydata"

OUTDIR="/gpfs1/home/s/r/srhousto/SydHoustonEcoGenomics/PopulationGenomics/mydata"

cd $INDIR

vcftools --gzvcf Lottia_gigantea_pl_flt3.renamed.vcf.gz --missing-indv --out $OUTDIR/missing_data
vcftools --gzvcf Lottia_gigantea_pl_flt3.renamed.vcf.gz --depth --out $OUTDIR/depth_data