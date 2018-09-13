wget "https://tandem.bu.edu/trf/trf407b.linux.download.html"
./trf pil.Genome.fa 2 7 7 80 10 50 2000 -d -h

Note: (1CPU,5memory)
2- match: matching weight
7- mismatch: mismatching weight
7- delta: indel penalty #低的权重值允许更多的“没匹配上”或“插入”的情况
80- PM: match probality
10- PI: indel probality
50- Minscore: minimum alignment score to repeat
2000- Maxperiod: maximum period size to repeat
options:
-d 产生屏蔽的串联重复序列的信息文件 
-h suppress html output
……

