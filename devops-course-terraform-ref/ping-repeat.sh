#!bin/bash
echo "Please enter number of ping repeats:"
read REP

echo "Enter IP or HTTP adress for pinging:"
read ADDRR
#Цикл, що виконує команду ping стільки разів
for x in {1..$REP}
do
  ping -c $REP $ADDRR
done
