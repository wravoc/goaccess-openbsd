#!/bin/ksh

######################################
# Elias Griffin
# Quadhelion Engineering
# https://www.quadhelion.engineering
# elias@quadhelion.engineering
######################################

######################################
# License Attribution
# ASN Data Provided by MaxMind
# https:/www.maxmind.com
# License CC BY 4.0
######################################

######################################
# License Attribution
# IP to ASN Data provided by DB-IP
# https://db-ip.com/
# License: CC BY 4.0
######################################

#######################################################################
# CUSTOMIZE -----------------------------------------------------------
# ---------------------------------------------------------------------
ASN_URL="https://download.db-ip.com/free/dbip-asn-lite-2023-05.mmdb.gz"
#
# MaxMind GitHub 2021
# "https://git.io/GeoLite2-ASN.mmdb"
#
# MaxMind Direct Updated (Requires Account)
# "https://www.maxmind.com/en/accounts/871098/geoip/downloads"
# CUSTOMIZE -----------------------------------------------------------
#######################################################################


ASN_FILE=$(echo ${ASN_URL} | sed 's:.*/::')
version=$(pkg_info goaccess | head -n 1)
DIR="$( cd "$( dirname "$0" )" && pwd )"
ASN_BASENAME=$(echo ${ASN_FILE%.*})
FULL_REPORT_DATE=$(stat -f "%t%Sm" /var/log/goaccess-total-report.html | awk '{print $1,$2;}')
CURRENT_MONTH_DAY=$(date '+%B %d')


## Check to see if user running script can write to /var
if id -nG "$USER" | grep -qw "wheel"; then
	echo "\\n********************\033[38;5;75m User Mode \033[0;0m************************"
	echo "Permissions are correct to write to /var/"
	echo "*******************************************************\\n"
else
	echo  "${USER} \033[38;5;9mdoes not have permission to write to /var/\033[0;0m"
	echo "*******************************************************\\n"
fi


## Script Usage
info()
{
   echo
   echo "********************\033[38;5;75m Base Mode \033[0;0m************************"
   echo "${version}"
   echo "Available mode: \033[38;5;208mfull\033[0;0m"
   echo "Argument full will combine all access.log.*.gz"
   echo "Arguement full will use all GeoIP Databases"
   echo "*******************************************************\\n"
}

## If ASN DB doesn't exist, ask user to download it 
if [ ! -f "/var/db/GeoIP/ASN.mmdb" ] ; then
    echo
	echo "\033[38;5;208mWould you like to download ASN Data to /var/db/GeoIP/GeoLite2-Country.mmdb\033[0;0m? (y/N)"
	read answer
	case $answer in
		y|Y|"")
			echo "*******************************************************"
			echo "\033[38;5;75mDownloading ASN Data \033[0;0m"
			echo "Destination: /var/db/GeoIP/GeoLite2-Country.mmdb"
			echo "*******************************************************"
			wget --header='Accept-Encoding: gzip' --tries=3 ${ASN_URL} && gunzip ${ASN_FILE}
			echo "****************\033[38;5;75m Unzipped, Moving File \033[0;0m****************"
			mv ${DIR}/${ASN_BASENAME} /var/db/GeoIP/ASN.mmdb
			echo 
			echo
			echo "*********************\033[38;5;76m Success \033[0;0m*************************\\n"
			;;
		no|n)
		    echo
			echo "*******************************************************"
			echo "\033[38;5;75mSkipping ASN Database \033[0;0m"
			echo "*******************************************************"
			;;
	esac
fi


## Check for ASN Install
if [ -f "/var/db/GeoIP/ASN.mmdb" ] ; then
	ASN_INSTALLED=1
else
	ASN_INSTALLED=0
fi
	

## Get script argument "full" or not
if [ $# -ne 1 ] ; then
   info
   
   
## Set report name with current date
date=`date +%b%e`
filename=goaccess-report-${date}.html


## Run correct report for just the current /var/www/logs/access.log
case $ASN_INSTALLED in
   1)
   	  echo
	  echo "*********************\033[38;5;75m Results \033[0;0m*************************"   
	  zcat -f /var/www/logs/access.log \
	   | grep -v 'logfile turned over$' \
	   | awk '$8=$1$8' \
	   | goaccess \
		   --no-global-config \
		   --ignore-crawlers \
		   --log-format='%v %h %^ %e [%d:%t %^] "%r" %s %b "%R" "%u" %^' \
		   --date-format='%d/%b/%Y' \
		   --time-format='%T' \
		   --geoip-database=/var/db/GeoIP/ASN.mmdb \
		   --geoip-database=/var/db/GeoIP/GeoLite2-Country.mmdb \
		   --output='/var/log/'${filename}
   echo "*******************************************************"
   ;;
   0)
   	  echo
   	  echo "*********************\033[38;5;75m Results \033[0;0m*************************"   
   	  zcat -f /var/www/logs/access.log \
    	| grep -v 'logfile turned over$' \
    	| awk '$8=$1$8' \
    	| goaccess \
        	--no-global-config \
			--ignore-crawlers \
        	--log-format='%v %h %^ %e [%d:%t %^] "%r" %s %b "%R" "%u" %^' \
        	--date-format='%d/%b/%Y' \
        	--time-format='%T' \
			--geoip-database=/var/db/GeoIP/GeoLite2-Country.mmdb \
        	--output='/var/log/'${filename}
			echo "*******************************************************"
	;;
	esac

	if [ -e /var/log/${filename} ]
   		then
		    echo
		    echo "*********************\033[38;5;76m Success \033[0;0m*************************"
      		echo "Report created at /var/log/${filename}"
      		echo "*******************************************************\\n"
   		else
      		echo "Error creating /var/log/${filename}"
      		echo "*******************************************************\\n"
	fi


## Run report for all web logs, include the gzipped logs with ASN data
else
 case $ASN_INSTALLED in
   1)
   	  echo
   	  echo "*********************\033[38;5;75m Results \033[0;0m*************************"
   	  echo
   	  zcat -f /var/www/logs/access.log* \
    	| grep -v 'logfile turned over$' \
    	| awk '$8=$1$8' \
    	| goaccess \
        	--no-global-config \
			--ignore-crawlers \
        	--log-format='%v %h %^ %e [%d:%t %^] "%r" %s %b "%R" "%u" %^' \
        	--date-format='%d/%b/%Y' \
        	--time-format='%T' \
			--geoip-database=/var/db/GeoIP/ASN.mmdb \
			--geoip-database=/var/db/GeoIP/GeoLite2-Country.mmdb \
        	--output='/var/log/goaccess-total-report.html'
	;;
	0)	
	   echo
	   echo "*********************\033[38;5;75m Results \033[0;0m*************************"
	   echo
	   zcat -f /var/www/logs/access.log* \
		| grep -v 'logfile turned over$' \
		| awk '$8=$1$8' \
		| goaccess \
			--no-global-config \
			--ignore-crawlers \
			--log-format='%v %h %^ %e [%d:%t %^] "%r" %s %b "%R" "%u" %^' \
			--date-format='%d/%b/%Y' \
			--time-format='%T' \
			--geoip-database=/var/db/GeoIP/GeoLite2-Country.mmdb \
			--output='/var/log/goaccess-total-report.html'
	;;
  esac	
  

	if [ -e /var/log/goaccess-total-report.html ] || [ FULL_REPORT_DATE == CURRENT_MONTH_DAY ]
   	then
	    echo
	    echo "*********************\033[38;5;76m Success \033[0;0m*************************"
      	echo "Report created at /var/log/goaccess-total-report.html"
      	echo "*******************************************************\\n"
   	else
      	echo "Error creating /var/log/goaccess.total-report.html"
      	echo "*******************************************************\\n"
	fi

fi
