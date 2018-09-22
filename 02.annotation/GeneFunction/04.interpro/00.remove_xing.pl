#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $ip = shift;
my $op = shift;
my $fa = Bio::SeqIO->new(-file=>$ip, -format=>'fasta');
open (O,">$op") or die ("$!\n");
while(my $seq= $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    if ($seq =~ /\*/){
	my $length = length $seq;
	my $newseq = substr ($seq,0,$length-1);
	print O ">$id\n$newseq\n";
    }
}
close O;
