pdf("mRNA_length.pdf");
a = read.table ('mRNA_length.head.txt',header=T)
library(ggplot2)
ggplot(a,aes(value,color=species))+geom_density()+ xlim(0,20000)+xlab("mRNA length")
dev.off();
pdf("CDS_length.pdf");
b=read.table ('CDS_length.head.txt',header=T)
ggplot(b,aes(value,color=species))+geom_density()+ xlim(0,8000)+xlab ("CDS length")
dev.off();
pdf("Exon_length.pdf");
c = read.table ('Exon_length.head.txt',header=T)
ggplot(c,aes(value,color=species))+geom_density()+ xlim(0,2000)+xlab ("Exon length")
dev.off();
pdf("Intron_length.pdf");
d = read.table ('Intron_length.head.txt',header=T)
ggplot(d,aes(value,color=species))+geom_density()+ xlim(0,2000)+xlab ("Intron length")
dev.off();
pdf("Exon_number.pdf");
e = read.table ('Exon_number.head.txt',header=T)
ggplot(e,aes(value,color=species))+geom_density(adjust=2)+ xlim(0,30)+xlab ("Exon_number")
dev.off();
