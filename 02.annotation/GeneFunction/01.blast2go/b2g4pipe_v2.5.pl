#!/usr/bin/perl -w
use strict;
my $dir="/home/share/software/blast2go/blast2go/b2g4pipe_v2.5";
my $file_pro="/share/work/user124/project/01.Populus_ilicifolia_genome/02.Annotation/03.function_annotation/01.blast2go/b2gPipe.properties";
my $result_dir = "pil_b2go_1to1.result";
my @xml_file = <01.pil_blastnr_1to1.xml/*>;
my $num = scalar @xml_file;
mkdir($result_dir)unless(-d $result_dir);
for (my $i = 0;$i<$num;$i++){
    #single.14660.xml
    my $file_in = "$xml_file[$i]";
    print "file_in:$file_in\n";
    # 01.pil_blastnr_1to1.xml/single.0.xml
    $file_in =~/single\.(\d+)\.xml$/;
    my $result_prefix = $1;
    my @j=`find $dir -name "*.jar"`;
    foreach (@j) {
	chomp ;
    }
    my $j=join(":",@j);
    my $cmd="java -Xmx6000m -cp $j: es.blast2go.prog.B2GAnnotPipe -in $file_in -out $result_dir/$result_prefix -prop $file_pro -v -annot -dat -img -annex -goslim ";
    print $cmd,"\n";
    system($cmd);
}
