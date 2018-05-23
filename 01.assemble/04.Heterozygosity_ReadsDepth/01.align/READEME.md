This papline is for align, includ:

### realign.md  
is the command line for align, rmdup, and realign  

### align.pl  
can used for producing all align command line  


### BamCount  
contants two scripts which can generate the basic count of the bam file:  
```
DepthCoverage.pl …… for depth and coverage information  
  
MapRatio.count.pl …… for mapration information  
```

### scripts  
contain many scripts for chart:
```
Base.Depth1.BasicCount.pl …… 计算每一个深度下对应的碱基数目

Base.Depth2.HistoGram.pl …… 可以生成全基因组depth柱状统计图：即把depth分成以10为一个区间，合并大于200的所有碱基数；得到每个深度区间中的碱基数目

Base.Depth3.Mean.Depth.pl …… 用于输出基因组的平均深度 #Base.Depth2与Base.Depth3需要用Base.Depth1的输出结果

GC.contant.pl …… 统计基因组GC含量分布，将组装的基因组以500bp为窗口，计算每个窗口的GC含量

GC.Depth.pl …… 统计每个窗口(20k)中GC含量和平均深度

GenomeSize.pl …… 通过读dict文件，统计基因组大小
```
