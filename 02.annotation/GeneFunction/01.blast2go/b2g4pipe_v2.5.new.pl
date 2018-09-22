#!/usr/bin/perl -w
use strict;
my $dir="/share/work/user124/project/01.Populus_ilicifolia_genome/02.Annotation/03.function_annotation/01.blast2go";
my $file_pro="/share/work/user124/project/01.Populus_ilicifolia_genome/02.Annotation/03.gennAnnontation/01.blast2go/b2gPipe.properties";
my $file_in="pil.blast.xml";
my $result_dir="pil_b2go_results";
my $results_prefix="pilb2g";

#my ($file_in,$result_dir,$result_prefix)=@ARGV or die "\$file_in,\$result_dir,\$result_prefix\n";
mkdir($result_dir)unless(-d $result_dir);
my @j=`find $dir -name "*.jar"`;
foreach (@j) {
    chomp ;
}
my $j=join(":",@j);
my $cmd="java -Xmx6000m -cp $j: es.blast2go.prog.B2GAnnotPipe -in $file_in -out $result_dir/$results_prefix -prop $file_pro -v -annot -dat -img -annex -goslim ";
print $cmd,"\n";
system($cmd);
