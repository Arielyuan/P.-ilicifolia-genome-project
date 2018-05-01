
## reads filtering

### 1.Before reads filtering
   Tips: before reads filtering, we need some preparation
#### 1.1 将数据链接到自己的目录下，并将相同reads合并在一起
   ```
   zcat 500bp_1_1.fq.gz  500bp_2_1.fq.gz | gzip - >500bp.1.fq.gz
   ```
#### 1.2 reads name:
   ```
   <1000bp: 字母+插入片段+bp+1/2.fq.gz  # Populus_ilicifolia.500bp.1.fq \ Populus_ilicifolia.500bp.2.fq
   >1000bp: 字母+插入片段+kbp+1/2.fq.gz # Populus_ilicifolia.5kbp.1.fq \ Populus_ilicifolia.5kbp.2.fq
   ```

### 2.reads filter  
#### 2.1 quality filter  
   filter reads with “N”s that constitute more than 5 percent of nucleotides  
   filter reads that have less than or equal to 65 percent of nucleotides with quality scores less than or equal to 7  
#### 2.2 using lighter to trim the Short-insert paired-end Illumina libraries (<2kbp)  
#### 2.3 removal of duplicates in long-insert paired-end Illumina libraries (>=2kb)


### 3.reads statistic

generate a reads-basic-information table include:
Insert Size(bp)\Reads Number\tReads Length(bp)\tTotal Data(bp)\tDepth(X)

 

