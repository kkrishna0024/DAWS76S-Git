#!/bin/bash/

name=""
wishesh=""

usage(){

      echo "USAGE: $(basename $0) -n <name> -w <wishes>"
      echo "options::"
      echo " -n, specify the name mandatory"
      echo "-w, specify the wishes. e, good morning"
      echo "-h, display help and exit"
      exit 1
}
 while getopts ":n:w:h" opt;
  do
      case $opt in
      
      n) name="$OPTARG" ;;
       w) wishes="$OPTARG" ;;
       :) usage; exit ;;
       \?) echo "error invalid options "$OPTARG"" >$2; usage;exit;;
      h|*) usage; exit1 ;;
     esac
done
