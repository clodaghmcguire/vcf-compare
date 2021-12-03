#!/bin/bash
truth=/data/pipeline/pipeline-validation/validation-data/GIAB_dedup/analysis/HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz
query=/data/pipeline/pipeline-validation/validation-data/GIAB_dedup/analysis/giab.all.vcf.gz
output=/data/pipeline/pipeline-validation/validation-data/GIAB_dedup/test
highconfidence=/data/pipeline/pipeline-validation/validation-data/GIAB_dedup/analysis/HG001_GRCh38_1_22_v4.2.1_benchmark.bed
reference=/data/pipeline/04_wgs/references/gatk/Homo_sapiens_assembly38.fasta

mkdir -p ${output}

bcftools view -v snps ${truth} | perl -lane 'if (/^#/) { print } elsif (length($F[3]) == 1) { print }' | bgzip > ${output}/benchmark.vcf.gz
tabix -p vcf ${output}/benchmark.vcf.gz

bcftools view -v snps ${query} | perl -lane 'if (/^#/) { print } elsif (length($F[3]) == 1) { print }' | bgzip > ${output}/pipeline.vcf.gz
tabix -p vcf ${output}/pipeline.vcf.gz

bedtools jaccard -a ${output}/benchmark.vcf.gz -b ${output}/pipeline.vcf.gz

bcftools isec ${output}/benchmark.vcf.gz ${output}/pipeline.vcf.gz -p isec

vcf-compare ${output}/benchmark.vcf.gz ${output}/pipeline.vcf.gz

/opt/hap.py/bin/hap.py ${output}/benchmark.vcf.gz ${output}/pipeline.vcf.gz -f ${highconfidence} -o ${output}/compare -r ${reference}
