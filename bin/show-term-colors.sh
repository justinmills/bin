#! /bin/bash

# Handy little script to show you all the colors you can pass into tput setaf (useful for setting
# your PS1 properly)

for ((i=0; i<256; i++)) ;do
    echo -n '  '
    tput setab $i
    tput setaf $(( ( (i>231&&i<244 ) || ( (i<17)&& (i%8<2)) ||
                         (i>16&&i<232)&& ((i-16)%6 <(i<100?3:2) ) && ((i-16)%36<15) )?7:16))
    printf " C %03d " $i
    tput op
    (( ((i<16||i>231) && ((i+1)%8==0)) || ((i>16&&i<232)&& ((i-15)%6==0)) )) &&
        printf "\n" ''
done
