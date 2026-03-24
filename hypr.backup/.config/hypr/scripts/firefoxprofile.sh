#!/bin/bash

workspace=$(hyprctl activeworkspace -j | jq -r '.name')
echo $workspace
case $workspace in
	1:Personal)
		#firefox -profile "/home/brian/.mozilla/firefox/gsmod22o.Personal"
		echo "Personal"
		firefox -P Personal
		;;
	2:IPMTech)
		#firefox -profile "/home/brian/.mozilla/firefox/gwg5oh1f.IPMTech"
		echo "IPMTech"
		firefox -P IPMTech
		;;
	3:DOI)
		#firefox -profile "/home/brian/.mozilla/firefox/6j8r3vtf.DOI"
		echo "DOI"
		firefox -P DOI
		;;
	5:Media)
		#firefox -profile "/home/brian/.mozilla/firefox/un5pypb5.Media"
		echo "Media"
		firefox -P Media
		;;
	4:Admin)
		#firefox -profile "/home/brian/.mozilla/firefox/ofph3zo7.Admin"
		echo "Admin"
		firefox -P Admin
		;;
	*)	
		#firefox -profile "/home/brian/.mozilla/firefox.gsmod22o.Personal"
		echo "No Match"
		firefox -P Personal
		;;
esac
