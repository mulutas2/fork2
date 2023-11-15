#!/bin/sh
#SBATCH --job-name=Cold_Day_5
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=120:00:00
#SBATCH --mem=30G
#SBATCH --error=Cold_Day_5.err
#SBATCH --output=Cold_Day_5.out
#SBATCH --licenses=common
GEMMA -bfile 278Sweet_corn_V5.miss05.maf001 -k 2Centered_IBS_kinship_GEMMA.txt -c 278_hyb_inb_land.pca_GEMMA.txt -p phenotype_GEMMA.txt -lmm 4 -n 7 -o Cold_Day_5 -miss 0.7 -r2 1 -hwe 0 -maf 0.05
