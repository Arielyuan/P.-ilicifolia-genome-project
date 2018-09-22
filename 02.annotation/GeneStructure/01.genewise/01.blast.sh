/home/user106/user124/software/blast-2.2.26/bin/formatdb -i pilGenome.fa -p F -o T -t 01.pil;
/home/user106/user124/software/03.gene_prediction/blast-2.2.26/bin/blastall -p tblastn -i cpa10.fa -d /home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/01.database/pilGenome.fa -e 1e-5 -o 01.tbnout.cpa.10 -a 8 #8G,1CPU
