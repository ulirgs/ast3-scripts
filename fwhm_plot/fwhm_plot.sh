#!/bin/bash
#-----------------------------------------------------------------------
# NAME:
#   fwhm_plot.sh
# PURPOSE:
#
# USAGE:
#   ./fwhm_plot.sh FILENANE
#   e.g. python altsun365.py 20140201_fwhm.dat
#
# INPUTS:
#   FILENANE: the filename of date file, which has these columns:
#
#	#yymmdd    hhmmss   name          ra        dec       fwhm a/b  theta  sky   nstar ccdtemp tempam  encra
#
#   e.g.:
#	#yymmdd    hhmmss   name          ra        dec       fwhm a/b  theta  sky   nstar ccdtemp tempam  encra
#	2014-03-23 18:53:03 20140323_0001.fits(obstype=survey 185.732055 67.976313 5.50 1.16 -13.79 4270.18 23 281.091 5.300 -80.787828
#
# OUTPUTS:
#	"file_name".jpg: the figure plot the
#	"file_name".map.jpg:
#
# OPTIONAL INPUTS:
#
# COMMENTS:
# 
# PROCEDURES DEPENDS:
#   circle.pro fsc_color.pro saveimage.pro tvread.pro
#   you can find those .pro file in dir "pro_lib"
#
# REVISION HISTORY:
# v3.0 2014/01/03 Weipeng
# v4.0 2014/01/07 Weipeng
#
#-----------------------------------------------------------------------

name=$1
name=${name%%.*}
awk '{print $1,$2}' $1 |sed 's/-/ /g;s/T/ /g;s/:/ /g' >date.tmp
sed 's/_/ /g' $1 | awk '{print $4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14}'>idl_dat.tmp
idl -e "fwhm_plot" #2> /dev/null 
rm *.tmp
mv fwhm.jpg $name.jpg
mv coor.jpg $name.map.jpg
