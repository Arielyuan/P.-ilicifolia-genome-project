#注：是06-2gff的结果将格式调整为负链基因的CDS区按照start从大到小排列得到的新gff
export PATH=$PATH:/home/user106/user124/software/03.gene_prediction/02.denovo/augustus-3.2.1/bin;
export AUGUSTUS_CONFIG_PATH=/home/user106/user124/software/03.gene_prediction/02.denovo/augustus-3.2.1/config/;
perl /home/user106/user124/software/03.gene_prediction/02.denovo/augustus-3.2.1/scripts/autoAugTrain.pl --genome=/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/00.pilGenome.fa --trainingset=/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/05.denovo/01.augustus_prediction/00.pil.Homolog.2.gff --species=pilnewformatefinal
