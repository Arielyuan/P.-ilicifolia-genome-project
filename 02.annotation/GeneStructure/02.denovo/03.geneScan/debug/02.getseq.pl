#! /usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;
use Bio::Seq;

my $scaffold=shift;
my $start=shift;
my $end=shift;

my $dir="./scaffolds/";

my $file=$dir.$scaffold.".fa";
my $in=Bio::SeqIO->new(-file=>$file,-format=>'fasta');
my $s=$in->next_seq;
my $id=$s->id;
my $seq=$s->seq;

my $length=$end-$start+1;
my $myseq=substr($seq,$start-1,$length);
my $mypro=&translate_nucl($myseq);
my $reverse=reverse($myseq);
$reverse=~tr/ATCG/TAGC/;
my $rev_pro=&translate_nucl($reverse);

my $dna_len=length($myseq);
my $pro_len=length($mypro);

print ">$id\_$start\_$end\n$dna_len\t$pro_len\n$myseq\n$mypro\n$reverse\n$rev_pro\n";

sub translate_nucl{
    my $seq=shift;
    my $seq_obj=Bio::Seq->new(-seq=>$seq,-alphabet=>'dna');
    my $pro=$seq_obj->translate;
    $pro=$pro->seq;
    return($pro);
}
