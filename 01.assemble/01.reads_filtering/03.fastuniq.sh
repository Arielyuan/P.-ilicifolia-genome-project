#### use Fastuniq to removal duplicates in long-insert paired-end Illumina libraries (>=2kb)

   #FastUniq v1.1

   ```
   fastuniq -i ip_2kbp.txt -t q -o op_2kbp.1.fq -p op_2kbp.2.fq
   ```

   Note: fastuniq不支持压缩文件，使用时要先解压 zcat ***.fq.gz > ***.fq  
         -i 后面不能直接跟reads, 要生成一个列表文件，里面写入一对pair-end reads的路径  
