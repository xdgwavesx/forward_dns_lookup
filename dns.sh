#!/bin/bash 


quit() {
	exit 1
}

trap quit SIGINT
trap quit SIGTERM

help() {
	echo "[*] Forward DNS Query"
        echo "[*] Usage: $0 <domain>"
	echo "[*]        $0 -d|--domain <megacorpone.com> [ -w|--wordlist wordlist ]"
        exit 0
}
[[ "$#" -lt 2 ]] && help


while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--domain) domain="$2"; shift ;;
        -w|--wordlist) wordlist="$2"; shift;;
        *) echo "Unknown parameter passed: $1"; help; exit 1 ;;
    esac
    shift
done


if [[ $wordlist = '' ]]
then
	wordlist="/opt/cyber/dns/dnsscan/subdomains.txt"
fi
echo -e "[*] Domain: $domain\n[*] Wordlist: $wordlist\n"

pids=""
for name in $( cat $wordlist )
do
	host $name.$domain | grep "has address" | cut -d " " -f 1,4 &
	pids+=" $!"
done	

wait $pids
