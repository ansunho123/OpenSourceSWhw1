#!/bin/bash

echo  "$ ./test.sh u.item u.data u.user"
echo "--------------------------"
echo "User Name : anseonho"
echo "Student Number : 12193231"
echo " [ MENU ] "
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre moives from 'u.item'"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’"
echo "4. Delete the ‘IMDb URL’ from ‘u.item'"
echo "5. Get the data about users from 'u.user’"
echo "6. Modify the format of 'release date' in 'u.item’"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

stop="N"
until [ $stop = "y" ]

do

read -p "Enter your choice [ 1-9 ] " choice
echo

case $choice in
1)	

		
	read -p "Please enter 'movie id' (1~1682): " id
    
        cat u.item|awk -F\|  -v a=$id '$1==a{print $0}'
    
	echo       
 ;;
2)
	read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n) :" check
	if [ "$check" = "y" ]; then		       	
	cat u.item|awk -F\| '$7==1{print $1,$2}'|awk 'NR<=10{print $0}'
	fi	

	echo 


        ;;
3)
	
	read -p "Please enter 'movie id' (1~1682): " id

	cat u.data | awk -v id=$id '$2==id {print $3}' | awk -v sum=$sum '{sum+=$1} END {print sum/NR}'	
	echo
	;;
4)
	read -p "Do you want to delete the 'IMDb URL' From 'u.item' ?(y/n) :" check

	if [ "$check" = "y" ]; then
	cat u.item |awk 'NR<=10{print $0}'|sed 's/http:\/\/[^|]*//'
	fi
	
	echo
	
        ;;
5)
        
	read -p "Do you want to get the data about users from 'u.user?' From 'u.item' ?(y/n) :" check
	
	if [ "$check" = "y" ]; then
	cat u.user | awk -F\| 'NR<=10 { print "user ", $1, " is " $2, " years old ", $3, $4 }' | sed 's/M/male/'| sed 's/F/female/'
	fi
	
	echo

	;;
6)
        read -p " Do you want to modify the format of 'release data' in 'u.item'?(y/n): " check
	if [ "$check" = "y" ]; then

	for i in {1673..1682}
	do


	a=$(cat u.item | awk -F\| -v id="$i" '$1==id{print $3}')

	month=$(echo "$a"| awk -F'-' '{print $2}')



	case $month in
  	 "Jan") num=01 ;;
  	 "Feb") num=02 ;;
  	 "Mar") num=03 ;;
  	 "Apr") num=04 ;;
  	 "May") num=05 ;;
  	 "Jun") num=06 ;;
  	 "Jul") num=07 ;;
  	 "Aug") num=08 ;;
  	 "Sep") num=09 ;;
  	 "Oct") num=10 ;;
  	 "Nov") num=11 ;;
  	 "Dec") num=12 ;;
  	 *) echo "유효하지 않은 월 이름입니다." ;;
	esac

	release=$(echo "$a"|awk -F'-' -v num="$num" '{print $3, num, $1}' | tr -d ' ')

	cat u.item | awk -F\| -v id="$i" '$1==id{print $0}' | sed "s/$a/$release/"
	done



	fi

	echo;
        ;;

7)
        read -p "Please enter 'user id' (1~943): " id
	
	echo;

	cat u.data | awk -v id=$id '$1==id{print $2}' | sort -n | tr '\n' '|' | sed 's/|$//'


	echo; echo;

	movie_id=$(cat u.data | awk -v id=$id '$1==id{print $2}' | sort -n| head -10)

	for id in $movie_id; do
        	cat u.item | awk -v id="$id" -F\| '$1==id{print $1,$2}'
	done

	echo


	;;
8)
        read -p " Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): " check

	if [ "$check" = "y" ]; then
       	id=$(cat u.user | awk -F\| '$2 >= 20 && $2 <= 29 && $4 ~"programmer" {print $1}' | tr -s '\n' ' ')

	for i in {1..1655}; do
    	sum=0
    	count=0

    	for j in $id; do
        rating=$(cat u.data | awk -v user_id="$j" -v movie_id="$i" '$1==user_id && $2==movie_id {print $3}')
        if [ -n "$rating" ]; then
            sum=$((sum + rating))
            count=$((count + 1))
        fi
   	 done

    	if [ "$count" -gt 0 ]; then
       		avg=$(awk -v sum="$sum" -v count="$count" 'BEGIN {print sum/count}')
        	echo "$i : $avg"
    	fi
  done
fi
	echo

        ;;
9)
        echo "Bye~"
	echo
        stop="y"
	;;
*)
        echo "please enter [1-9]"
       	echo
        ;;

esac
done
