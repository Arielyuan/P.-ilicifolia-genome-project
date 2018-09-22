#! /usr/bin/perl
#此脚本用来将gff里面的信息,过滤掉有提前终止密码子的情况；过滤掉没有起始密码子和终止密码子的情况，并将翻译的蛋白质输出和cds输出
use strict;
use warnings;
use Bio::SeqIO;
use Bio::Seq;

sub translate_nucl{
    my $seq=shift;
    my $seq_obj=Bio::Seq->new(-seq=>$seq,-alphabet=>'dna');
    my $pro=$seq_obj->translate;
    $pro=$pro->seq;
    return($pro);
}

my ($gff,$genome_fa,$op_gff)=@ARGV;
die "Usage: $0 <gff file> <genome file> <output_gff>\n" if(@ARGV<3);

my %hash;
my %gff;
open(I,"< $gff");
my $no=0;
while(my $eve = <I>){
    my $gene_name;
    chomp($eve);
    next if($eve =~ /^#/);
    my @a=split(/\s+/,$eve);
    if ($a[8] =~ /.+(scaffold(.+));/){
        $gene_name = $2;
#	print "$gene_name\n";
    }
    if($a[2] eq "CDS"){
	$no++;
	my ($chr,$start,$end,$strand,$phase)=($a[0],$a[3],$a[4],$a[6],$a[7]);
	$chr=~s/chr//g;
	$gff{$chr}{$gene_name}{$no}{start}=$start;
	$gff{$chr}{$gene_name}{$no}{end}=$end;
	$gff{$chr}{$gene_name}{$no}{strand}=$strand;
	$gff{$chr}{$gene_name}{$no}{phase}=$phase;
    }
    $hash{$gene_name} .= $eve."\n";
}
close I;

my $fa=Bio::SeqIO->new(-file=>$genome_fa,-format=>'fasta');

open(O,"> $op_gff");
open(E1,"> pilpredict.cds");
open(E2,"> pilpredict.pep");
open(E3,"> wrong_gene");
while(my $seq=$fa->next_seq){
    my $chr=$seq->id;
    my $seq=$seq->seq;
    #print ">$id\n$seq\n";
    next unless(exists $gff{$chr});
    foreach my $gene_name(keys %{$gff{$chr}}){
        my $strand="NA";
        my $line="";
        foreach my $no(sort { $gff{$chr}{$gene_name}{$a}{start} <=> $gff{$chr}{$gene_name}{$b}{start} } keys %{$gff{$chr}{$gene_name}}){
            if($strand eq "NA"){
		$strand=$gff{$chr}{$gene_name}{$no}{strand};
            }
            my $start=$gff{$chr}{$gene_name}{$no}{start};
            my $end=$gff{$chr}{$gene_name}{$no}{end};
            my $len=$end-$start+1;
            my $subline=substr($seq,$start-1,$len);
            $line.=$subline;
        }
        if($strand eq "+"){
            my $pep=translate_nucl($line);
	    if (($line =~ /^ATG/) && ($pep =~ /\*$/)){
		my $length = length ($pep);
		my $newseq = substr ($seq,0,$length-1);
		if ($newseq !~ /\*/){
		    print O "$hash{$gene_name}";
		}
		print E1 ">$gene_name\n$line\n";
		print E2 ">$gene_name\n$pep\n";
	    }	
	    else{
		print E3 "$gene_name\n";
	    }
	}
        elsif($strand eq "-"){
            $line=reverse($line);
            $line=~tr/ATCGatcg/TAGCtagc/;
            my $pep=translate_nucl($line);
	    if (($line =~ /^ATG/) && ($pep =~ /\*$/)){
		my $length = length ($pep);
                my $newseq = substr ($seq,0,$length-1);
                if ($newseq !~ /\*/){
                    print O "$hash{$gene_name}";
		    print E1 ">$gene_name\n$line\n";
		    print E2 ">$gene_name\n$pep\n";
		}
            }
            else{
                print E3 "$gene_name\n";
            }
        }
    }
}
close O;
close E1;
close E2;
close E3;
