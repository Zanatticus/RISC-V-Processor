#!/bin/bash
export PATH=/export/thishost/riscv/bin:$PATH
while getopts i:o:b: flag
do
	case "${flag}" in
		            i) first=${OPTARG};;
			    o) second=${OPTARG};;
			    b) third=${OPTARG};;
	esac
done
riscv32-unknown-linux-gnu-as $first  -march=rv32imac -o $second
riscv32-unknown-linux-gnu-objdump -D $second > $third
python3 converter.py --file $third
