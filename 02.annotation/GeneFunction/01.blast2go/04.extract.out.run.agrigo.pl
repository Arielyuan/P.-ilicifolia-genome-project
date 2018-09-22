#!/usr/bin/perl -w
use strict;
my $ip = "04.pil.all.blast2go.annot";
open (I,"<$ip") or die "$!\n";
while (my $eve = <I>){
    next if ($eve =~ /EC/);
    chomp ($eve);
    my @a = split/\s+/,$eve;
    print "$a[0]\t$a[1]\n";
}

close I;
