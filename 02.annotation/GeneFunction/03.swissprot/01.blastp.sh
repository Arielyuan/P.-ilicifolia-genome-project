/share/work/software/blast/ncbi-blast-2.2.31+/bin/makeblastdb -in uniref90.fasta -dbtype prot -out pil_swissprot;
/share/work/software/blast/ncbi-blast-2.2.31+/bin/blastp -query pil.pep -db pil_swissprot -evalue 1e-5 -outfmt 6 -num_threads 10 -out 01.swissprot_blastp.out
