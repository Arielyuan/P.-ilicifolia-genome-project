#!/usr/bin/perl -w
use strict;
my $ip = shift;
my $op = shift;
open (F,"<$ip") or die ("$!\n");
open (O,">$op") or die ("$!\n");

my $no = 0;
my %hash;
my %homolog_type;
while (my $eve = <F>){
    chomp ($eve);
    next if($eve=~/^\s*$/);
    if ($eve =~ /^!/){
	next;
    }elsif($eve =~ /^#/){
	$no ++;
    }else{
	my @a = split/\s+/,$eve;
	my $type = $a[-1];
	if(!$type){
	    die "$eve\n@a\n";
	}
#	print "$type\n";
	my @eve_type = split/,/,$type;
	foreach my $eve_type (@eve_type){
# 	    print "$eve_type\n";
#	     $eve_type =~ /{([^\(\);]+);([^\(\);]+)}/;
	    $eve_type =~ /{(.+);(.+)}/;
	    my $type_name = $2;
	    # print "$type_name\n";
	    if ($type_name eq "GlimmerHMM" || $type_name eq "AUGUSTUS" || $type_name eq "GeneScan"){
		$hash{$no}{denovo}++;
	    }elsif($type_name eq "Cpapaya" || $type_name eq "Rcommunis" || $type_name eq "Populus_trichocarpa" || $type_name eq "Populus_euphratica" || $type_name eq "Athaliana"){
		$homolog_type{$type_name}++;
		$hash{$no}{homolog}++;
	    }
	}
    }
}

foreach my $type(sort keys %homolog_type){
    print "$type\t$homolog_type{$type}\n";
}

my $homolog_num=0;
my $denovo_num=0;
my $both_num = 0;
foreach my $gene (sort keys %hash){
    if (exists $hash{$gene}{denovo} && exists $hash{$gene}{homolog}){
	$both_num++;
    }elsif (exists $hash{$gene}{denovo}){
	$denovo_num++;
    }elsif (exists $hash{$gene}{homolog}){
	$homolog_num++;
    }
}

print O "both_num:$both_num\ndenovo_num:$denovo_num\nhomolog_num:$homolog_num\n";
