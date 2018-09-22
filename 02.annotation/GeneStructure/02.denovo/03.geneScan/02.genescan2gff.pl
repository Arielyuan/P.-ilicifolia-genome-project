#!/usr/bin/perl -w
use strict;
#过滤标准：score大于50的exon要超过一半
my $op_standard_gff = shift;
my @gff_file = @ARGV;
open (O,">$op_standard_gff") || die ("!\n");
foreach (my $i=0;$i<@ARGV;$i++){
    open (F,"<$gff_file[$i]") || die ("!\n");
    <F>;
    <F>;
    my $scaffold_line = <F>;
    my @line = split/\s+/,$scaffold_line;
    my $scaffold_name = $line[1];
    <F>;
    <F>;
    <F>;
    <F>;
    <F>;
    <F>;
    <F>;
    <F>;
    my %hash;
    my %raw;
    my %valid;
    while (my $eve = <F>){
	chomp ($eve);
	next if ($eve =~ /^NO/);
	my $neweve=$eve;
	$neweve=~s/^\s+//;
	if ($neweve =~ /^(\d+)/){
	    my @infor = split (/\s+/,$neweve);
	    my $gene_num;
	    if ($infor[0]=~ /(\d+).(\d+)/){
		$gene_num = $1;
	    }
	    my $gene_name = $scaffold_name.".".$gene_num;
	    $hash{$gene_name}{$infor[1]}++; #$hash用来判断有没有init或sngl;
	    $raw{$gene_name}{infor} .= $neweve."\n"; #把每一个基因每一行的信息连起来存在$raw这个hash中;
	    $raw{$gene_name}{strand} = $infor[2];#基因的正负链信息;
	}
    }

    foreach my $gene_name (sort keys %hash){
	if (exists $hash{$gene_name}){
	    if (exists $hash{$gene_name}{"Init"} || $hash{$gene_name}{"Sngl"}){
		my @array;
		my @array1 = split/\n/,$raw{$gene_name}{infor};#选出有init和angl的基因,@array包括的是一个基因的全部信息，以下都是一个基因！！
		if ($raw{$gene_name}{strand} eq "-"){
		    @array = reverse @array1;
		}elsif($raw{$gene_name}{strand} eq "+"){
		    @array = @array1;
		}
		my %filter;
		my $last_length;
		my $phase;
		my @position;
		my $rna_score;
		my $scaffold_name;
		my %minus;
		if ($gene_name =~ /(.+)\./){
		    $scaffold_name = $1;
		}
		foreach my $eve (@array){
		    my @infor = split/\s+/,$eve;
		    if ($infor[2] eq "-"){
			my $tmp = $infor[3];
                        $infor[3] = $infor[4];
                        $infor[4] = $tmp;			
		    }
		    # print STDERR "hello\n";
		    if ($infor[1] eq "Init" || $infor[1] eq"Sngl"){
			$rna_score += $infor[12]; 
			# print STDERR "Enter\n";
			push (@position,($infor[3],$infor[4]));
			$valid{$gene_name}{plus}{firstcds} = "$scaffold_name\tGeneScan\tCDS\t$infor[3]\t$infor[4]\t$infor[10]\t$raw{$gene_name}{strand}\t0\tParent=$gene_name;\t\n";
			$filter{$gene_name}{exon_num}++;
			$filter{$gene_name}{exon_score} += $infor[10];
			$filter{$gene_name}{exon_posibility} += $infor[11];
			if ($infor[10] > 50){
			# if ($infor[11] > 0){
                            $filter{$gene_name}{highquilty_num}++;
                        }
			$last_length = $infor[5];
			if ($last_length%3==0){
			    $phase = 0;
			}else{
			    $phase = 3-($last_length%3);
			}
		    }elsif ($infor[1] eq "Intr" || $infor[1] eq "Term"){
			$rna_score += $infor[12];
			push (@position,($infor[3],$infor[4]));
			$valid{$gene_name}{plus}{cds} .= "$scaffold_name\tGeneScan\tCDS\t$infor[3]\t$infor[4]\t$infor[10]\t$raw{$gene_name}{strand}\t$phase\tParent=$gene_name;\t\n";
			$filter{$gene_name}{exon_num}++;
                        $filter{$gene_name}{exon_score} += $infor[10];
                        $filter{$gene_name}{exon_posibility} += $infor[11];
			if ($infor[10] > 50){
			# if ($infor[11] > 0){
			    $filter{$gene_name}{highquilty_num}++;
			}
			$last_length += $infor[5];
			if ($last_length%3==0){
			    $phase = 0;
			}else{
			    $phase = 3-($last_length%3);
			}
		    }
		}
		if(!$position[0]){
		    print STDERR "HERE!\n@position\n";
		}
		#过滤输出
		if(!exists $filter{$gene_name}{highquilty_num}){
		    $filter{$gene_name}{highquilty_num}=0;
		}
		#if (($filter{$gene_name}{exon_score}/$filter{$gene_name}{exon_num}>50) && ($filter{$gene_name}{exon_posibility}/$filter{$gene_name}{exon_num}>0.5) && ($filter{$gene_name}{highquilty_num}/$filter{$gene_name}{exon_num}>0.3)){
		if ($filter{$gene_name}{highquilty_num}/$filter{$gene_name}{exon_num} > 0.5){
		# if ($filter{$gene_name}{highquilty_num}>=1){
		    if($raw{$gene_name}{strand} eq "+"){
			print O "$scaffold_name\tGeneScan\tmRNA\t$position[0]\t$position[$#position]\t$rna_score\t$raw{$gene_name}{strand}\t.\tID=$gene_name;\t\n";
		    }elsif ($raw{$gene_name}{strand} eq "-"){
			print O "$scaffold_name\tGeneScan\tmRNA\t$position[$#position-1]\t$position[1]\t$rna_score\t$raw{$gene_name}{strand}\t.\tID=$gene_name;\t\n";
		    }
		    print O "$valid{$gene_name}{plus}{firstcds}";
#		if(!exists $valid{$gene_name}{plus}{cds}){
#		    die "$valid{$gene_name}{plus}{firstcds}\n";
#		}
		    if(exists $valid{$gene_name}{plus}{cds}){
			print O "$valid{$gene_name}{plus}{cds}";
		    }
		}
	    }		
	}
    }
close F;
}
close O;
