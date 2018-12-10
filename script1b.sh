#!/bin/bash 

function test(){

			while read -r previousSiteLine
			do

				if [[ $SiteLine == ${previousSiteLine:0:${#SiteLine}} ]]
				then
					IsFirst="no"
	
					if [[ "$SiteLine $md5" == $previousSiteLine ]]
					then
	
						IsSame="yes"
					else
						IsSame="no"
					fi
				fi
	
			done < "previous"

			
}

touch previous

while read -r SiteLine
do

if [[ ${SiteLine:0:1} != "#" ]]
 	then 
		if [[ ! $(wget $SiteLine -O-) ]] 2>/dev/null
		then	
			echo "$SiteLine FAILED"
		else	
			wget -q "$SiteLine"
  			md5="$(md5sum index.html)"
  			rm index.html
  			md5=($md5)  
		
			IsSame="no"
			IsFirst="yes"
			
			echo "$SiteLine $md5" >> previous
			
			if [[ $IsFirst == "yes" ]]
			then
				echo "$SiteLine  INIT"

			elif [[ $IsSame != "yes" ]]
      			then
				echo "$SiteLine" 
			fi


		fi

  	fi
   test &
done < "$1"

wait()


