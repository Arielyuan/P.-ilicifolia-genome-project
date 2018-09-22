#! /usr/bin/env perl
use strict;
use warnings;

my $in_xml = shift;
my $output_dir = shift;
`mkdir $output_dir` if(!-e $output_dir);

my $prefix = "<?xml version=\"1.0\"?>
<!DOCTYPE BlastOutput PUBLIC \"-//NCBI//NCBI BlastOutput/EN\" \"http://www.ncbi.nlm.nih.gov/dtd/NCBI_BlastOutput.dtd\">
<BlastOutput>
  <BlastOutput_program>blastp</BlastOutput_program>
  <BlastOutput_version>BLASTP 2.2.31+</BlastOutput_version>
  <BlastOutput_reference>Stephen F. Altschul, Thomas L. Madden, Alejandro A. Sch&amp;auml;ffer, Jinghui Zhang, Zheng Zhang, Webb Miller, and David J. Lipman (1997), &quot;Gapped BLAST and PSI-BLAST: a new generation of protein database search programs&quot;, Nucleic Acids Res. 25:3389-3402.</BlastOutput_reference>
  <BlastOutput_db>/home/share/data/genome/blastDB/20140727_161738/nr</BlastOutput_db>
  <BlastOutput_query-ID>Query_1</BlastOutput_query-ID>
  <BlastOutput_query-def>query1</BlastOutput_query-def>
  <BlastOutput_query-len>261</BlastOutput_query-len>
  <BlastOutput_param>
    <Parameters>
      <Parameters_matrix>BLOSUM62</Parameters_matrix>
      <Parameters_expect>10</Parameters_expect>
      <Parameters_gap-open>11</Parameters_gap-open>
      <Parameters_gap-extend>1</Parameters_gap-extend>
      <Parameters_filter>F</Parameters_filter>
    </Parameters>
  </BlastOutput_param>
<BlastOutput_iterations>
";
my $suffix = "</BlastOutput_iterations>\n</BlastOutput>\n";

open(I,"< $in_xml") or die "Cannot open $in_xml!\n";
my $name = 0;
while(<I>){
    next unless(/^\<Iteration\>/);
    open(O,"> $output_dir/single.$name.xml");
    print O "$prefix";
    print O "$_";
    while(<I>){
	print O "$_";
	if(/^\<\/Iteration\>/){
	    print O "$suffix";
	    last;
	}
    }
    $name++;
    close O;
}
close I;
