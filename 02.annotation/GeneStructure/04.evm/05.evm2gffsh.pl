#!/usr/bin/perl -w
use strict;
my @file = glob "04.evm_result/*.out";
my $out_put = $0.".sh";
open (O, ">$out_put") or die ("$!\n");
my $scaffold_name;
my $result_dir = "06.evm_out.gff3";
`mkdir $result_dir` if (!-e $result_dir);
foreach my $evm_out_file(@file){
#    print "$evm_out_file\n";
#    04.evm_result/scaffold10002_cov156
    if ($evm_out_file =~ /04.evm_result\/(.+)\.evm.out/){
        $scaffold_name = $1;
    }else{
	print "wrong!!";
    }
#    print "$scaffold_name\n";
    print O "/home/user106/user124/software/03.gene_prediction/03.EVidenceModeler-1.1.1/EvmUtils/EVM_to_GFF3.pl $evm_out_file $scaffold_name >$result_dir/05.$scaffold_name.gff3\n";
#    last;
}
close O;
