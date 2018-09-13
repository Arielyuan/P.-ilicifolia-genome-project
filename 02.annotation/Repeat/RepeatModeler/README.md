# Repeatmodeler用于Denovo预测转座子 

# 1.Repeatmodeler的安装:  
```
http://www.repeatmasker.org/RepeatModeler.html 
wget http://www.repeatmasker.org/RepeatModeler-open-1-0-8.tar.gz
./configure #安装
```
Note: 1.安装时要注意安装RepeatScout-1和RECON-1，查看install或readme文件，进行安装;  
      2. trf的软件名字为trf时，才能安装成功

2.Repeatmodeler参数设置： 

2.1 建数据库
```
[RepeatModelerPath]/BuildDatabase -name <新库的名字>(如elephant) (-engine ncbi) 基因组.fa文件(如scaffold_efficient.fa)
```  

2.2 运行Repeatmodeler建立library
```
[RepeatModelerPath]/RepeatModeler -database <新库的名字> 
```
Note:跑完这一步之后会出现一个RM_<PID>.<DATE>格式的文件夹，例如："RM_5098.MonMar141305172005"，在该文件夹下找到consensi.fa.classified文件，该文件可为Repeatmasker所用)  

2.3 运行repeatmasker寻找重复序列
```
[RepeatMaskerPath]/RepeatMasker -lib consensi.fa.classified mySequence.fa(参考repeatmasker) 
```
