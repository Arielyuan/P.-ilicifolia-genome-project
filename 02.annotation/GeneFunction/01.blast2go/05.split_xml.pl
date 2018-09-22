#!/usr/bin/perl -w
use strict;
use Bio::SearchIO;
my $searchin = Bio::SearchIO ->new (-formate=>'blastxml',-file=>'../01.blastnr.out/pil10.xml');

while (my $result = $searchin -> next_result){
    my $query_name = $result->query_name;
    open O (">$query_name") or die ("$!\n");
    print O "$result\n";
    close O;
}
