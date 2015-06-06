#!/bin/bash

case=

stgvol=${config/stgvoltxt_filepattern}
stgvol=${stgvol/\$case/$case/}

redo-ifchange ../stgvolcalc-pipeline/$case.STGVolume.txt

# findでファイルをフルパスで取得する。lsではフルパスではない。（配列になるのかどうかは不明。）
find ../stgvolcalc-pipeline/*.STGVolume.txt -maxdepth 1 -mindepth 1 > FileList
FileListNumber=${#FileList[*]}

#insert fields into list
FieldName=("caseID","rtaaSTG","lsaaSTG","rtpaSTG","lspaSTG","rtapSTG","lrapSTG","rtppSTG","lsppSTG",)
echo $FIeldName >> $3
echo "/n" >> $3

# FileListからパスと拡張子を取り除きたい。For文をつかわなければいけないのかは不明。　


# insert values of volumes into list
for i in `expr seq 1 $FileListNumber` do
  j=`expr i - 1`
  echo $FileList[j] >> $3
  echo `$FileList[j]` >> $3
  echo "/n" >> $3
done
