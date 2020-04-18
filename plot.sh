#!/bin/sh

if [ $# != 1 ]; then
    echo "error!, \$1: matrix market filename"
    exit 1
fi

filename=$1

while read R C NZ T1 T2; 
do
	echo $R | grep -v '^%.*' > /dev/null
	if [ $? -eq 0 ]; then
		ROW=$R
		NNZ=$NZ
		break
	fi
done < $filename

TITLE=$filename\(N=$ROW,NNZ=$NNZ\)
PSIZE=`echo "scale=10; 1.0 / $ROW" | bc`

gnuplot << EOF
set terminal pdfcairo enhanced
set output "MMplot.pdf"
#set terminal png size $ROW,$ROW font ",100"
#set output "MMplot.png"

set size square
set datafile commentschars "%"

set title '$TITLE'
set pm3d map
unset xtics
unset ytics
unset key

set xrange [1:$ROW] 
set yrange [$ROW:1]

splot '$filename' every ::1::$NNZ with points pointtype 7 pointsize $PSIZE lc rgb "black"
EOF
