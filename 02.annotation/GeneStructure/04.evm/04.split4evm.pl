#! /usr/bin/env perl
use strict;
use warnings;

my $genome_dir="04.genome_split"; # 输入的基因组文件
my $denovo="00.pilfinal.gene.gff";
my $protein="00.pil.final.protein.gff";
my $transcriptom= "pasa_zyDB.pasa_assemblies.gff3";
my $outdir="04.gff_scaffolds";
my $resultdir="04.evm_result";

`mkdir $outdir` if(!-e $outdir);
`mkdir $resultdir` if(!-e $resultdir);
my %scaffolds;

&split_gff($denovo,"denovo");
&split_gff($protein,"protein");
&split_gff($transcriptom,"transcriptom");

open(O,"> $0.sh");
foreach my $scaffold(sort keys %scaffolds){
    if (exists $scaffolds{$scaffold}{denovo}&& exists $scaffolds{$scaffold}{protein} && exists $scaffolds{$scaffold}{transcriptom}){
	print O "/home/user106/user124/software/03.gene_prediction/03.EVidenceModeler-1.1.1/evidence_modeler.pl --genome $genome_dir/$scaffold.fa --weights 01.EvidenceWeightsFile --gene_predictions $outdir/$scaffold.denovo.gff --protein_alignments $outdir/$scaffold.protein.gff --transcript_alignments $outdir/$scaffold.transcriptom.gff > $resultdir/$scaffold.evm.out\n";
    }elsif(exists $scaffolds{$scaffold}{denovo} && exists $scaffolds{$scaffold}{protein}){
	print O "/home/user106/user124/software/03.gene_prediction/03.EVidenceModeler-1.1.1/evidence_modeler.pl --genome $genome_dir/$scaffold.fa --weights 01.EvidenceWeightsFile --gene_predictions $outdir/$scaffold.denovo.gff --protein_alignments $outdir/$scaffold.protein.gff > $resultdir/$scaffold.evm.out\n";
    }elsif(exists $scaffolds{$scaffold}{denovo} && exists $scaffolds{$scaffold}{transcriptom}){
	print O "/home/user106/user124/software/03.gene_prediction/03.EVidenceModeler-1.1.1/evidence_modeler.pl --genome $genome_dir/$scaffold.fa --weights 01.EvidenceWeightsFile --gene_predictions $outdir/$scaffold.denovo.gff --transcript_alignments $outdir/$scaffold.transcriptom.gff > $resultdir/$scaffold.evm.out\n";
    }elsif(exists $scaffolds{$scaffold}{denovo}){
        print O "/home/user106/user124/software/03.gene_prediction/03.EVidenceModeler-1.1.1/evidence_modeler.pl --genome $genome_dir/$scaffold.fa --weights 01.EvidenceWeightsFile --gene_predictions $outdir/$scaffold.denovo.gff > $resultdir/$scaffold.evm.out\n";
    }
}
close O;

sub split_gff{
    my $gff=shift;
    my $suffix=shift;
    open(I,"< $gff");
    while(<I>){
	chomp;
	next unless(/^(\S+)/);
	my $scaffold=$1;
	$scaffolds{$scaffold}{$suffix}++;
	open(O,">> $outdir/$scaffold.$suffix.gff");
	print O "$_\n";
	close O;
    }
    close I;
}
