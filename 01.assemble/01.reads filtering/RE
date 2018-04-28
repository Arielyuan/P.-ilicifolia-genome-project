## reads filtering

### 1.reads filter  
#### 1.1 quality filter  
   filter reads with “N”s that constitute more than 5 percent of nucleotides  
   filter reads that have less than or equal to 65 percent of nucleotides with quality scores less than or equal to 7  
#### 1.2 using lighter to trim the Short-insert paired-end Illumina libraries (<2kbp)  
   ```
   #lighter v1.0.7
   lighter -r scriptfilter.500bp.1.filter.fq.gz -r scriptfilter.500bp.2.filter.fq.gz -k 17 600000000 0.156 -t 20 -trim
   ```
#### 1.3 removal of duplicates in long-insert paired-end Illumina libraries (>=2kb)
   ```
   #FastUniq v1.1
   fastuniq -i ip_2kbp.txt -t q -o op_2kbp.1.fq -p op_2kbp.2.fq
   ```
