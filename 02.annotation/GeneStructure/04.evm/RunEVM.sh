#cp /home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/02.genePrediction/06.evm/20160505.evm.plustranscriptom.version/01.run_pasa/pasa_zyDB.pasa_assemblies.gff3 .;
cat ../../04.runGenwise/04.modified_gff/01-5.ath.rank.gff ../../04.runGenwise/04.modified_gff/02-5.cpa.rank.gff ../../04.runGenwise/04.modified_gff/03-5.peu.rank.gff ../../04.runGenwise/04.modified_gff/04-5.ptr.rank.gff ../../04.runGenwise/04.modified_gff/05-5.rco.rank.gff > 00.pil.raw.protein.gff;
cat ../../05.denovo/01.augustus_prediction/augustus.maskTE.20160427/04.augustus.fincompletegene.gff ../../05.denovo/02.glimmerHmm_prediction/glimmer_maskTE.20160427/04.glimmer_filter_incompletegene.gff ../../05.denovo/03.genescan_prediction/03-7.genescan_Fincompletegene.gff ../../05.denovo/05.geneMark_prediction/20160429.genemark.maskTE.version/04.genemarkf_incompletegene.gff >00.pil.raw.gene.gff;
./01-1.adjustProteinGff.pl 00.pil.raw.protein.gff 00.pil.final.protein.gff;
./01-2.adjustGeneGff.pl 00.pil.raw.gene.gff 00.pilfinal.gene.gff;
./03.split_genome.pl 00.pilGenome.fa;
./04.split4evm.pl;
/home/software/multi 30 04.split4evm.pl.sh 04.split4evm.pl.sh.out;
./05.evm2gffsh.pl;