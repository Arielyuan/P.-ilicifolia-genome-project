This papline is for SNP calling, includes:

### 01.Call.SNP.md  
is the command line for using samtools and gatk calling SNP.

### 02.call.samtools.pl 
for generate 'samtools call snp by chr' command line.  

### 03.call.gatk.chr.pl  
for generate 'gatk call snp by chr' command line.

### 03.call.gatk.window.pl  
for generate 'gatk call snp by window' command line. 

### Scripts 
include many scripts used for evalute heterozygosity and other information:

The first two scripts are used to roughly evalute the heterozygosity after generate the draft genome.
```
01.SNPcount_filter.samtools.pl 
用于生成基因组杂合度分析图（以20kb为窗口，统计过滤后每个窗口SNP的数量以及其占每个窗口的比例#此脚本还将输出过滤后的vcf)

02.genome_heter.pl 
统计整个基因组的杂合度（需要用到01的脚本输出来的文件）
```

The rest of scripts are used in population re-sequencing data to roundly evalute heterozygosity. #based on the results of gatk snp calling.
```
03.add.allsite.removeindel5bp.pl
1.跳过了多等位基因突变的情况；2.将所有的深度在1/3与3倍之间的非snp位点补充为0/0，其他的变为./.；3. 过滤掉indel以及indel前后5bp的位点。 

03.run.add.allsite.removeindel5bp.pl 
生成03.add.allsite.removeindel5bp.pl 的sh文件

04.filterQualityDepthMiss.pl 
过滤覆盖度不在min_depth(1/3*mean_depth)和max_depth(3*mean_depth)之间的情况，以及质量值小于30的情况（换成./.）。若有效的信息（miss）小于个体数的一半（50%），就把这个位点去掉。
04.run.filterQualityDepthMiss.pl 
生成04.filterQualityDepthMiss.pl 的sh文件

05.merge.pl 
将所有染色体的vcf合并到一起

06.count.heter.pl 
输出每个个体的杂合度 
06-2.count.heter.mean.sd.pl 
统计所有杂合度的平均值和标准差

07.internal.difference.pl 
分染色体统计两两个体之间差异的基因型占所有位点的比例。如AT和TT之间的差异是0.5,总共的位点为非./.的位点，一个计数为1

07.run.internal.difference.pl 
生成07.internal.difference.pl 的sh文件

07.3.settle.difference.pl 
处理07.internal.difference.pl 的结果文件，即将每条染色体的输出结果整合到一起，算整个基因组的差异

#其他的结果在群体分析中查看
```
