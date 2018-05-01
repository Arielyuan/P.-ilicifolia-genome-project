## Assemble papline

   This papline include:

   0. estimate genome size

   1. assemble Sequence reads with Platanus  
      Reads with 500bp and 800bp insert size were used to constructs contigs using the algorithm based on de Bruijn graph.  
      the order of contigs is determined according to paired-end (mate-pair) data and all reads were used to constructs scaffolds.  
      paired-end reads localized on gaps in scaffolds were assembled and gaps were closed.

   2. use Soap Gapcloser to ulteriorly close gap
 
   3. filter the reads whitch length less than 200bp (N was exclude)

   4. count the quality of assembly
