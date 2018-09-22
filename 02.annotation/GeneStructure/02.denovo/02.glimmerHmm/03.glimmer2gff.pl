#!/usr/bin/perl -w
use strict;
my $gff_file = shift;
my $op_standard_gff = shift;
open (F,"<$gff_file") || die ("!\n");
open (O,">$op_standard_gff") || die ("!\n");
while (my $eve = <F>){
    chomp ($eve);
    if ($eve =~ /^\w+/){
	my @infor = (split/\s+/,$eve);
	if ($infor[2] eq "mRNA"){
	    if($infor[8] =~ /(.+);(.+)/){
		$infor[8] = $1;
	    }
	}elsif ($infor[2] eq "CDS"){
	    if($infor[8] =~ /(.+);(.+);(.+)/){
		$infor[8] = $2;
	    }
	}
	my $neweve = join "\t",@infor;
       	print O "$neweve;\t\n";
    }
}
close F;
close O;
