#!/usr/bin/bash
#needs exif package installe. 

#Script checks each JPG or jpg if it finds  
#exif tag 0x9004 (Date Time Digitized) it updates file creation time to match or 
#if tag 0x9004 is not present it will try 0x9003 (Date Time Original) and update file creation time to match.
#could it be cleaner. Yes. Specfically getting the date stamp out of the exif. 
#Does it work. Yes.

filetypes=("*.jpg" "*.JPG")

for ext in ${filetypes[@]}; do 
  echo $ext
  for jpgfile in $ext; do
  [ -f "$jpgfile" ] || break
  #echo "$jpgfile"
  jpgdate=`exif $jpgfile -t 0x9004 $jpgfile | grep "Value" | awk -F: {'print $2$3$4$5"."$6'} | awk {'print $1$2'}`
  jpgdate=`echo $jpgdate | awk {'print$2'}`  
  #echo $jpgdate
  if [[ $jpgdate ]]; then
    echo "Updating $jpgfile timestamp to match exif 0x9004 (Date Time Digitizied)"
    touch -t $jpgdate $jpgfile 
  else
    echo "Unable to find EXIF Tag 0x9004 or other EXIF issue."
    echo "Trying EXIF tag 0x9003 (Date time Original)."
    jpgdate=`exif $jpgfile -t 0x9003 $jpgfile | grep "Value" | awk -F: {'print $2$3$4$5"."$6'} | awk {'print $1$2'}`
    jpgdate=`echo $jpgdate | awk {'print$2'}`
    if [[ $jpgdate ]]; then
      echo "Found 0x9003 tag. Updating $jpgfile to match exif 0x9003 tag."
      touch -t $jpgdate $jpgfile
	  else    
	    echo "Still getting error giving up on file $jpgfile" 
    fi	
  fi	
  done
done
