## Assemble Sequence reads with Platanus:  
1.Reads with 500bp and 800bp insert size were used to constructs contigs using the algorithm based on de Bruijn graph.  
2.the order of contigs is determined according to paired-end (mate-pair) data and all reads were used to constructs scaffolds.  
3.paired-end reads localized on gaps in scaffolds were assembled and gaps were closed.  

 #platanus v1.2.1
 
 1.contig
 ```
 platanus assemble  -o 01.contig -f 01.CleanReads/scriptfilter.500bp.1.filter.cor.fq 01.CleanReads/scriptfilter.500bp.2.filter.cor.fq 01.CleanReads/scriptfilter.800bp.1.filter.cor.fq 01.CleanReads/scriptfilter.800bp.2.filter.cor.fq -t 50 -m 500
 #result: 01.contig_contig.fa
 ```
 
 2.scaffold
 ```
 platanus scaffold -o 02.scaffold -b 01.contig_contigBubble.fa -c 01.contig_contig.fa -t 50 -IP1 01.CleanReads/scriptfilter.500bp.1.filter.cor.fq 01.CleanReads/scriptfilter.500bp.2.filter.cor.fq -IP2 01.CleanReads/scriptfilter.800bp.1.filter.cor.fq 01.CleanReads/scriptfilter.800bp.2.filter.cor.fq -OP3 01.CleanReads/op_2kbp.1.fq 01.CleanReads/op_2kbp.2.fq -OP4 01.CleanReads/op_5kbp.1.fq 01.CleanReads/op_5kbp.2.fq -OP5 01.CleanReads/op_10kbp.1.fq 01.CleanReads/op_10kbp.2.fq
 #result: 02.scaffold_scaffold.fa
 ```
 
 3.gap_close
 ```
 platanus gap_close -c 02.scaffold_scaffold.fa -o 03.platanusGapClose -t 50 -IP1 01.CleanReads/scriptfilter.500bp.1.filter.cor.fq 01.CleanReads/scriptfilter.500bp.2.filter.cor.fq -IP2 01.CleanReads/scriptfilter.800bp.1.filter.cor.fq 01.CleanReads/scriptfilter.800bp.2.filter.cor.fq -OP3 01.CleanReads/op_2kbp.1.fq 01.CleanReads/op_2kbp.2.fq -OP4 01.CleanReads/op_5kbp.1.fq 01.CleanReads/op_5kbp.2.fq -OP5 01.CleanReads/op_10kbp.1.fq 01.CleanReads/op_10kbp.2.fq
 #result：03.platanusGapClose_gapClosed.fa
 ```
