#/share/work/software/blast/ncbi-blast-2.2.31+/bin/makeblastdb -in uniprot_trembl.fasta -dbtype prot -out pil_trembl;
/share/work/software/blast/ncbi-blast-2.2.31+/bin/blastp -query pil.pep -db pil_trembl -evalue 1e-5 -outfmt 6 -num_threads 30 -out 01.trembl_blastp.out
