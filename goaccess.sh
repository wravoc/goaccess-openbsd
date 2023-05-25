#cc!/bin/ksh

version=$(pkg_info goaccess | head -n 1)

info()
{
   echo
   echo "********************\033[38;5;75m Base Mode \033[0;0m************************"
   echo "${version}"
   echo "*******************************************************"
   echo "Available mode: \033[38;5;208mfull\033[0;0m"
   echo "Argument full will combine all access.log.*.gz"
   echo "*******************************************************\\n"
}

if [ $# -ne 1 ] ; then
   info
   
   date=`date +%b%e`
   filename=goaccess-report-${date}.html

   echo
   echo "********************\033[38;5;75m Results \033[0;0m**************************"   
   zcat -f /var/www/logs/access.log \
    | grep -v 'logfile turned over$' \
    | awk '$8=$1$8' \
    | goaccess \
        --no-global-config \
        --log-format='%v %h %^ %e [%d:%t %^] "%r" %s %b "%R" "%u" %^' \
        --date-format='%d/%b/%Y' \
        --time-format='%T' \
        --output='/var/log/'${filename}
echo "*******************************************************"

if [ -e /var/log/${filename} ]
   then
      echo "Report created at /var/log/${filename}"
      echo "*******************************************************\\n"
   else
      echo "Error creating /var/log/${filename}"
      echo "*******************************************************\\n"
fi

else
   echo
   echo "********************\033[38;5;75m Results \033[0;0m**************************"
   echo
   zcat -f /var/www/logs/access.log* \
    | grep -v 'logfile turned over$' \
    | awk '$8=$1$8' \
    | goaccess \
        --no-global-config \
        --log-format='%v %h %^ %e [%d:%t %^] "%r" %s %b "%R" "%u" %^' \
        --date-format='%d/%b/%Y' \
        --time-format='%T' \
        --output='/var/log/goaccess-total-report.html'
   echo "*******************************************************"

if [ -e /var/log/goaccess-total-report.html ]
   then
      echo "Report created at /var/log/goaccess-total-report.html"
      echo "*******************************************************\\n"
   else
      echo "Error creating /var/log/goaccess.total-report.html"
      echo "*******************************************************\\n"
fi

fi
