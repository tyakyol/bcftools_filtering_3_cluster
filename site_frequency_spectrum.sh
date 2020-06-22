#!/bin/bash
#SBATCH --partition normal
#SBATCH --mem-per-cpu 128g
#SBATCH -c 2
#SBATCH -t 96:00:00

vcftools --vcf results/only_INDELs.recode.vcf \
--counts \
--out results/INDELs_no_filter

vcftools --vcf results/only_SNPs.recode.vcf \
--counts \
--out results/SNPs_no_filter

vcftools --vcf results/first_filtering_INDELs.recode.vcf \
--counts \
--out results/INDELs_first_filter

vcftools --vcf results/first_filtering_SNPs.recode.vcf \
--counts \
--out results/SNPs_first_filter

Rscript INDELs_no_filter_site_frequency_spectrum.R results/INDELs_no_filter.frq.count results/INDELs_no_filter_site_frequency_spectrum.pdf

Rscript SNPs_no_filter_site_frequency_spectrum.R results/SNPs_no_filter.frq.count results/SNPs_no_filter_site_frequency_spectrum.pdf

Rscript INDELs_first_filter_site_frequency_spectrum.R results/INDELs_first_filter.frq.count results/INDELs_first_filter_site_frequency_spectrum.pdf

Rscript SNPs_first_filter_site_frequency_spectrum.R results/SNPs_first_filter.frq.count results/SNPs_first_filter_site_frequency_spectrum.pdf
