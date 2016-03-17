#!/bin/csh
#read fits head and ast3skysurvey log
#fwhmstat.csh v1.0 2014/01/02 Weipeng
#usage fwhmstat.csh yyyymmdd
#output - /media/main2d1/fwhm_stat/yyyymmdd_fwhm.dat

set bindir = /ast3/bin
set confighome = /ast3/etc
set sdir = /home/ast3/fwhm_stat
cd $sdir
set t = `date +%s -d "$1"`
@ t1 = $t + 3600 * 16
@ t2 = $t + 3600 * 32
#mysql  -u root -p'1'  -e "select from_unixtime(time) as 'time',content from mohe.mohelog where time between $t1 and $t2 order by time" | grep Preprocess |sed 's/\tPreprocess: filename = \/ast3\/var\/images\// /g;s/.fits(objtype = survey, ra = / /g;s/, dec=/ /g;s/\\nfwhm elong theta sky nstar / / g' > $sdir/tmpfile
#mysql  -u root -p'1'  -e "select from_unixtime(time) as 'time',content from mohe.mohelog where time between $t1 and $t2 order by time" | grep Preprocess |sed 's/Preprocess\:/ /g;s/.fits(obsname=survey, RA=/ /g;s/, DEC=/ /g;s/): fwhm=/ /g;s/, elong=/ /g;s/, theta=/ /g;s/, sky=/ /g;s/, nstar=/ /g' > $sdir/tmpfile
 mysql  -u root -p'1'  -e "select from_unixtime(time) as 'time',content from mohe.mohelog where time between $t1 and $t2 order by time" | grep 'survey' |sed 's/Preprocess\:/ /g;s/, RA=/ /g;s/, DEC=/ /g;s/): fwhm=/ /g;s/, elong=/ /g;s/, theta=/ /g;s/, sky=/ /g;s/, nstar=/ /g;s/, exptime=/ /g;s/, date_obs=/ /g;/FLAT/d;/write/d;/Double/d' > $sdir/tmpfile

echo '#yymmdd    hhmmss   name          ra        dec       fwhm a/b  theta  sky   nstar ccdtemp tempam  encra     ' > $sdir/fwhm.dat

foreach filename ( /media/*/*/$1*.fits )
  set image = `basename $filename`
  set filedir = `dirname $filename`


  set ra = `$bindir/gethead $filedir/$image RA`
  set dec = `$bindir/gethead $filedir/$image DEC`
  set ccdtemp = `$bindir/gethead $filedir/$image CCDTEMP`
  set tempam = `$bindir/gethead $filedir/$image TEMPAM`
  set encra = `$bindir/gethead $filedir/$image ENCRA`
  set nstar = `grep ${image:r} tmpfile|awk '{print $12}'`
  if ( "x$nstar" != "x" ) then
    echo `grep ${image:r} tmpfile|awk '{print $1,$2,$3}'` $ra $dec `grep ${image:r} tmpfile|awk '{print $8,$9,$10,$11/$6,$12}'` $ccdtemp $tempam $encra>> $sdir/fwhm.dat
  endif
end
cat fwhm.dat
sed -i 's/_a/_/g' fwhm.dat
sed -i 's/_b/_/g' fwhm.dat
echo '#yymmdd    hhmmss   name          ra         dec       fwhm a/b  theta  sky   nstar ccdtemp tempam  encra     ' 
cd $sdir
mv fwhm.dat $1_fwhm.dat
bash fwhm_plot.sh $1_fwhm.dat
rm tmpfile
rsync -avP /home/ast3/fwhm_stat ast3op@159.226.88.76:/home/ast3op/
