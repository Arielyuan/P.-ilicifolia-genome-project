#cat peu.rename.cds ppr.rename.cds >peu-ppr.rename.cds;
#/home/user106/user124/software/03.gene_prediction/PASApipeline-2.0.2/seqclean/seqclean/seqclean peu-ppr.rename.cds;
/home/user106/user124/software/03.gene_prediction/PASApipeline-2.0.2/scripts/Launch_PASA_pipeline.pl -c confshixiong.txt -C -R -g pilGenome.fa -t peu-ppr.rename.cds.clean -T -u peu-ppr.rename.cds --ALIGNERS blat,gmap --CPU 10
