# GoAccess Tools for OpenBSD 7.3

[GoAccess](https://goaccess.io/) is an open source **real-time** **web log analyzer** and interactive viewer that runs in a **terminal** in *nix systems or through your **browser**.

It provides **fast** and valuable HTTP statistics for system administrators that require a visual server report on the fly.

----

![](images/GoAccessOpenBSDtheme.png)



## Helpers for GoAccess 1.7.1 on OpenBSD 7.3

OpenBSD has some quirks dealing with log formats so to make it easier I have made a preconfigured *goaccess.conf* and some simple shell scripts to execute commands that work with the default package version.



## Features

* OpenBSD Themed

* IP Exclusions for [Uptime Robot](https://uptimerobot.com/?rid=d8e3c5122ea836) Web Monitoring 

* Simplified shell script for single and combined log reporting output to HTML

  

## Obtain

1. `pkg_add goaccess`



## Backup

1. Backup `/etc/goaccess/goaccess.conf` and then put repository version in place



## Execute

1. `chmod 750 goaccess.sh`
2. `goaccess` (Uses OpenBSD theme, GeoIP, and Exclusions)
3. `goaccess.sh` to create an HTML report for the current log *(no options used)*
4. `goaccess.sh full` to combine all logs (including gzipped) into one report *(no options used)*
5. Check your `/var/log`
    1. `goaccess-report-Month-Day.html`
    2. `goaccess-total-report.html`



## Customize

After you've made your first reports you can choose to get more out of your logs and GoAccess

1.  Inside the `server` section of your `httpd.conf` add the directive `log style combined`
2. `rcctl reload httpd`
3. Change shell script as needed. Add any [options](https://goaccess.io/man#options) for the shell script needed, some popular ones
    `--exclude-ip='216.144.248.23'
	`--enable-geoip=<legacy|mmdb>`



**LICENSE**

[GoAccess Tools for OpenBSD](https://bitbucket.org/quadhelion-engineering/goaccess-openbsd) © 2023 by [Elias Christopher Griffin](https://www.eliasgriffin.com) is licensed under CC BY-NC-SA 4.0. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
