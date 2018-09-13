#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $file=shift;
my $fa = Bio::SeqIO->new(-file=>$file, -format=>'fasta');
my $sh = shift;
while(my $seq = $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    `mkdir $id`;
    my $fastafile = $id ."/".$id.".fa";
    open (A,">$fastafile") || die "!/n";
    print A ">$id\n$seq\n";
    close A;
    if (-e "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/01.repeat/05.mergeAndFilter/gff/$id/$id.gff"){
	open (S,">>$sh") || die "!/n";
	print S "/home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/01.repeat/05.mergeAndFilter/05.mask.pl /home/user106/user124/project/01.Populus_ilicifolia_genome/02.Annotation/01.repeat/05.mergeAndFilter/gff/$id/$id.gff $fastafile $id/op1 $id/op2\n";
	close S;
    }else{
	my $op1 = $id . "/" ."op1";
	my $op2 = $id . "/" ."op2";
	open (O1,">$op1") || die "!/n";
	open (O2,">$op2") || die "!/n";
	print O1 ">$id\n$seq\n";
	close O1;
	print O2 ">$id\n$seq\n";
        close O2;
    }
}
