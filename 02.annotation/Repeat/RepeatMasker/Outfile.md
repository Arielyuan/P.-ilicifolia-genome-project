Repeatmasker have 4 outputfiles：
1. XXX.out (main file)
formate:
```
SW perc perc perc query position in query matching repeat position in repeat score div. del. ins. sequence begin end (left) repeat class/family begin end (left) ID
640 14.6 0.6 0.0 scaffold100015_cov36 42 212 (476) + (TTA)n Simple_repeat 2 173 (0) 1 
340 27.4 1.7 1.7 scaffold100084_cov50 347 461 (8) C ATCopia69_I-int LTR/Copia (247) 4023 3909 6

640: 比对上的Smith-Waterman 分值
14.6: 比上区间与共有序列相比的分化率即diverge
0.6: 在查询序列中的碱基缺失的百分率（删除碱基）
0.0: 在查询序列中的碱基缺失的百分率（插入碱基）
scaffold100015_cov36：查询序列的名称
42: 比对上区间在查询序列中的起始位置
212: 比对上区间在查询序列中的终止位置
(476): 表示里查询序列3'末端还有多少碱基
+: 表示被比对上的重复序列在查询序列中是处于正链还是负链，+表示正链，C表示负链
(TTA)n: 比对上的Repbase库中重复序列的名称
Simple_repeat: 重复序列所属的家族
2: 比上区间在Repbase库中重复序列的起始位置
173: 比上区间在Repbase库中重复序列的终止位置
(0): 比上区间离3'末端的碱基数目
Note: 若第九列为C(负链)，则这三列数目倒过来，总是"()"内的数字代表的是(left)
1: 序列ID
```

2. XXX.masked: mask掉重复序列的基因组文件

3. XXX.tbl: 重复序列各种信息的表格

4. XXX.cat: 此文件内容同 .out