#### use lighter to trim the Short-insert paired-end Illumina libraries (<2kbp)  

   #lighter v1.0.7

   ```
   lighter -r scriptfilter.500bp.1.filter.fq.gz -r scriptfilter.500bp.2.filter.fq.gz -k 17 600000000 0.156 -t 20 -trim
   ```

   Note: -r 后面加reads，如果reads很多，可以往后面跟很多 -r ***reads 
         600000000 估计的基因组大小
         0.156 α值，α=7/平均测序深度，需要自己计算出来

