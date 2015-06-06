#!/bin/bash -e

# SetUpData.shからファイル場所などの変数を読み込むことにする。
# $caseを実際の番号に置き換えるのはどの部分ですればいいんだっけ？
source SetUpData.sh


for i in `seq 1 8`
do
  low=`expr $i - 0.5`
  up=`expr $i + 0.5`
  stats=`fslstats Image -l $low -u $up -V`
  Number=`expr $i - 1`
  SubVolumes[$Number]=${stats[0]}
done

echo $SubVolumes > $3
