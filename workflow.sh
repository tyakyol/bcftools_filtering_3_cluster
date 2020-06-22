# vcf file for INDELs only
vcftools --vcf ../../InRoot/variant_calling_7/results/20200531_raw_variants.vcf \
--keep-only-indels \
--recode \
--recode-INFO-all \
--out results/only_INDELs

# vcf file for SNPs only
vcftools --vcf ../../InRoot/variant_calling_7/results/20200531_raw_variants.vcf \
--remove-indels \
--recode \
--recode-INFO-all \
--out results/only_SNPs

# Convert the vcf file for INDEls to tabular form for first filtering
bcftools query -H \
-f '%CHROM\t%POS\t%QUAL\t%DP\t%HOB\t%MQSB\t%MQ0F\t%MQ[\t%GT\t]\n' \
results/only_INDELs.recode.vcf > results/first_filtering_INDELs.tsv

# Convert the vcf file for SNPs to tabular form for first filtering
bcftools query -H \
-f '%CHROM\t%POS\t%QUAL\t%DP\t%MQ[\t%GT\t]\n' \
results/only_SNPs.recode.vcf > results/first_filtering_SNPs.tsv

# First filtering: generating INDEL_positions.tsv
Rscript INDEL_tsv_filtering.R results/first_filtering_INDELs.tsv results/INDEL_positions.tsv

# First filtering: generating SNP_positions.tsv
Rscript SNP_tsv_filtering.R results/first_filtering_SNPs.tsv results/SNP_positions.tsv

# First filtering for INDELs: applying INDEL_positions.tsv
vcftools --vcf results/only_INDELs.recode.vcf \
--positions results/INDEL_positions.tsv \
--recode \
--recode-INFO-all \
--out results/first_filtering_INDELs

# First filtering for SNPs: applying SNP_positions.tsv
vcftools --vcf results/only_SNPs.recode.vcf \
--positions results/SNP_positions.tsv \
--recode \
--recode-INFO-all \
--out results/first_filtering_SNPs

# Second filtering for INDELs (MAF filtering)
vcftools --vcf results/first_filtering_INDELs.recode.vcf \
--maf 0.05 \
--recode \
--recode-INFO-all \
--out results/second_filtering_INDELs

# Second filtering for SNPs (MAF filtering)
vcftools --vcf results/first_filtering_SNPs.recode.vcf \
--maf 0.05 \
--recode \
--recode-INFO-all \
--out results/second_filtering_SNPs

# Convert the vcf file (only INDELs) to tabular form for historgrams
bcftools query -H \
-f '%CHROM\t%POS\t%QUAL\t%DP\t%VDB\t%SGB\t%MQ0F\t%ICB\t%HOB\t%AC\t%AN\t%DP4\t%MQ\t%IDV\t%IMF\t%MQSB[\t%GT\t]\n' \
results/second_filtering_INDELs.recode.vcf > results/second_filtering_INDELs.tsv

# Convert the vcf file (only SNPs) to tabular form for histograms
bcftools query -H \
-f '%CHROM\t%POS\t%QUAL\t%DP\t%VDB\t%SGB\t%RPB\t%MQB\t%MQSB\t%BQB\t%MQ0F\t%ICB\t%HOB\t%AC\t%AN\t%DP4\t%MQ[\t%GT\t]\n' \
results/second_filtering_SNPs.recode.vcf > results/second_filtering_SNPs.tsv

# Histogram for filtered INDELs
Rscript INDEL_histograms.R results/second_filtering_INDELs.tsv results/INDEL_histograms.pdf

# Histogram for filtered SNPs
Rscript SNP_histograms.R results/second_filtering_SNPs.tsv results/SNP_histograms.pdf
