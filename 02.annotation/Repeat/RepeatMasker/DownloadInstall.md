Befor we use repeatmasker annoate repeats, we need download software and some databases.

1. RepeatMasker download and install

1.1 download repeatmasker
http://www.repeatmasker.org/RMDownload.html  
```
wget "http://www.repeatmasker.org/RepeatMasker-open-4-0-6.tar.gz"
```

1.2 download search engine RMBlast
http://www.repeatmasker.org/RMBlast.html
```
wget "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/2.2.28"
wget "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.28"
tar zxvf ncbi-blast-2.2.28+-x64-linux.tar.gz
tar zxvf rmblast-2.2.28-x64-linux.tar.gz
cp -R rmblast-2.2.28/* ncbi-blast-2.2.28+/
rm -rf rmblast-2.2.28
mv ncbi-blast-2.2.28+ rmblast-2.2.28
```

1.3 download search engine ABBlast  
http://blast.advbiocomp.com/
Not:需要用川大的邮箱注册，然后会把包发到邮箱中，直接下载即可。

1.4 download trf (see parent directory)

1.5 install repeatmasker
```
cd /usr/local/RepeatMasker
emacs RepeatMakser(进入Repeatmasker软件，将其第一行perl的路径改为自己服务器上perl的路径)
perl ./configure
```

2. repbase download and install
2.1 download
http://www.girinst.org/repbase/
Not:需要用川大的邮箱注册，然后会把包发到邮箱中，直接下载即可。

2.2 install
Not:将Repeatmasker文件夹里的Library文件夹与Repbase解压后的Library文件夹合并，重点是将RepeatMaskerLib.embl更新为最新版本
