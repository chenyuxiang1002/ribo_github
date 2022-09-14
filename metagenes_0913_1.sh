#!/bin/bash
declare -a StringArray=("L.gtf" "laltop.gtf" "loperon.gtf" "sd_all.gtf" "unassigned.gtf" "utr_all.gtf" "lalt.gtf" "led_all.gtf" "sd.gtf" "sd_operon.gtf" "utr.gtf" "utr_operon.gtf")
declare -a files_arr=("RiboseqT0Rep_1_CKDL220012951-1a-AK3640_HHM2MCCX2_L1" "RiboseqT0Rep_2_CKDL220012951-1a-AK1942_HHM2MCCX2_L1" "RiboseqT30HRep_1_CKDL220012951-1a-AK5506_HHM2MCCX2_L1" "RiboseqT30HRep_2_CKDL220012951-1a-AK6969_HHM2MCCX2_L1" "RiboseqT30KRep_1_CKDL220012951-1a-48_HHM2MCCX2_L1" "RiboseqT30KRep_2_CKDL220012951-1a-AK1074_HHM2MCCX2_L1" "RiboseqT6HRep_1_CKDL220012951-1a-14_HHM2MCCX2_L1" "RiboseqT6HRep_2_CKDL220012951-1a-40_HHM2MCCX2_L1" "RiboseqT6KRep_1_CKDL220012951-1a-AK5039_HHM2MCCX2_L1" "RiboseqT6KRep_2_CKDL220012951-1a-AK2330_HHM2MCCX2_L1")

out_dir="/Users/yuxiangchen/Desktop/output"
mkdir -p "$out_dir"
read_dir="/Users/yuxiangchen/Library/CloudStorage/OneDrive-UCSF/Data/2022/Ksg Riboseq RNAseq/riboseq_processed_batch2/ribSeq/bams"
annot_dir="/Users/yuxiangchen/Desktop/riboseq/Metagene/different gene categories/others/"


# gtf="L.gtf"
# nme="RiboseqT0Rep_1_CKDL220012951-1a-AK3640_HHM2MCCX2_L1"


for gtf in ${StringArray[@]}
do
  metagene generate "${out_dir}/${gtf/.gtf/}" \
    --landmark cds_start \
    --downstream 150 \
    --annotation_files "${annot_dir}/${gtf}"

  for nme in ${files_arr[@]}
  do
    metagene count "${out_dir}/${gtf/.gtf/_rois.txt}" \
      "${out_dir}/${nme}_count_${gtf/.gtf/}" \
      --count_files "${read_dir}/${nme}.bam" \
      --threeprime \
      --offset 14 \
      --normalize_over 30 200 \
      --min_counts 20 \
      --cmap Blues

      phase_by_size "${out_dir}/${gtf/.gtf/_rois.txt}" \
       "${out_dir}/${nme}_phase_${gtf/.gtf/}" \
      --count_files "${read_dir}/${nme}.bam" \
      --threeprime \
      --offset 14 \
      --codon_buffer 5 \
      --min_length 25 \
      --max_length 35
  done
done