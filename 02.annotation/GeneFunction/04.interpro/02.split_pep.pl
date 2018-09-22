#!/usr/bin/env perl
use strict;
use warnings;
use Bio::SeqIO;

my $input_fasta="pil_noxing.pep";
my $outdir="00.pil_noxing.pep";
`mkdir $outdir` if (!-e $outdir);
my $num=340;

my $fa=Bio::SeqIO->new(-file=>$input_fasta,-format=>'fasta');

my $outfile_id=0;
my $i=0;
while(my $seq_obj=$fa->next_seq){
    my $id=$seq_obj->id;
    my $seq=$seq_obj->seq;
    if($i==$num){
	$i=0;
    }
    if($i==0){
	$outfile_id++;
	close O;
	open(O,"> $outdir/pil.$outfile_id.pep") or die "Cannot write!\n";
    }
    print O ">$id\n$seq\n";
    $i++;
}
close O;
