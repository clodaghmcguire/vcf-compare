#!/bin/bash

docker run  -v /data/data:/data --name vcf-compare clodagh/hap.py:v1.0 bash /data/pipeline/pipeline-validation/validation-data/GIAB_dedup/vcf-compare.sh