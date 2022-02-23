#!/bin/bash

sum=0
for (( i = 1; i <= $1; i++ ))
do
  sum=$[ $sum + $i ]
done
echo "sum is $sum"

