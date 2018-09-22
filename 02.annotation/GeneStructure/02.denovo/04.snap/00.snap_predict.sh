perl 01.gff2zff.pl 00.pilHomolog.gff 00.pilGenome.fa piltrain.fa pilgene.zff;
#01.gff2zff.pl脚本可以把gff文件转为zff文件，并同时按顺序输出fasta的文件
/home/user106/user124/software/03.gene_prediction/02.denovo/snap/fathom pilgene.zff piltrain.fa -gene-stats > gene-stats.log 2>&1;
/home/user106/user124/software/03.gene_prediction/02.denovo/snap/fathom pilgene.zff piltrain.fa -validate > validate.log 2>&1;
/home/user106/user124/software/03.gene_prediction/02.denovo/snap/fathom pilgene.zff piltrain.fa -categorize 1000 > categorize.log 2>&1;
/home/user106/user124/software/03.gene_prediction/02.denovo/snap/fathom uni.ann uni.dna -export 1000 -plus > uni-plus.log 2>&1;
mkdir params;
cd params;
/home/user106/user124/software/03.gene_prediction/02.denovo/snap/forge ../export.ann ../export.dna > ../forge.log 2>&1;
cd ..;
/home/user106/user124/software/03.gene_prediction/02.denovo/snap/hmm-assembler.pl pil params/ > pil.hmm;
/home/user106/user124/software/03.gene_prediction/02.denovo/snap/snap pil.hmm ../00.pilGenome.fa > pilpredict.zff;
/home/user106/user124/software/03.gene_prediction/02.denovo/snap/zff2gff3.pl pilpredict.zff >pilpredict.gff3;