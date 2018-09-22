#!/usr/bin/perl -w
use strict;
use Bio::SeqIO;
my $gene_file=shift;
my $genome_file = shift;
my $fa = Bio::SeqIO->new(-file=>$genome_file, -format=>'fasta');
my %hash;
my $less2000_scaffold;
my $less1000_scaffold;
while(my $seq = $fa->next_seq){
    my $id = $seq->id;
    my $seq = $seq->seq;
    my $scaffold_length = length ($seq);
    $hash{$id} = $scaffold_length;
    if ($scaffold_length < 2000){
	$less2000_scaffold++;
	if ($scaffold_length < 1000){
	    $less1000_scaffold++;
	}
    }
}

print "less2000_scaffold:$less2000_scaffold\nless1000_scaffold:$less1000_scaffold\n";
open (F,"<$gene_file") || die ("$!\n");
my $less_than2000_num = 0;
my $less_than1000_num = 0;
while(my $eve = <F>){
    chomp($eve);
    my @a = split/\s+/,$eve;
    my $scaffold_name = $a[0];
    my $type = $a[2];
    if ($type eq "mRNA"){
	if ($hash{$scaffold_name} < 2000){
#	    print "lessthan2000\t$scaffold_name\t$hash{$scaffold_name}\t\n";
	    $less_than2000_num++;
	    if ($hash{$scaffold_name} < 1000){
#		print "lessthan1000\t$scaffold_name\t$hash{$scaffold_name}\t\n";
		$less_than1000_num++;
	    }
	}
    }else{
	next;
    }
}
print "less_than2000_num:$less_than2000_num\nless_than1000_num:$less_than1000_num\n";
close F;
