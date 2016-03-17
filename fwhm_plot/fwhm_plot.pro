;+
; fwhm_plot v3.0 2014/01/03 Weipeng
; fwhm_plot v4.0 2014/01/07 Weipeng
; - output
;   fwhm.jpg 
;-

pro fwhm_plot
readcol,"idl_dat.tmp",format='f,f,f,f,f,f,f,f,f,f,f',	$
	id,ra,dec,fwhm,elong,theta,bk,nstar,ccdtemp,tempam,encra
readcol,"date.tmp",yy,mm,dd,h,m,s

t=h+(m/60.)+(s/3600.)
if (where(t lt 12))[0] ne -1 then t[where(t lt 12)]+=24
ccdtemp-=273.16
n=n_elements(id)
jdcnv,yy,mm,dd,(h-8)+m/60.+s/3600.,jd
glactc,ra,dec,2000,gl,gb,1,/DEGREE
glactc,ra20,dec20,2000,indgen(360),indgen(360)*0+20,2,/degree
alt=ra
azi=ra
for ii=0,n-1 do eq2hor, ra[ii], dec[ii], jd[ii], alt[ii], azi[ii],lat=53.55833,lon=122.340872

sym1=[4,4,4,4,4,4,4,4]
xtickn=[" ",string(18,20,22,0,2,4,6,f='(i2)')," "]
xticks=8
symsize=0.3
y=fltarr(8,n)
y[0,*]=fwhm    & y[1,*]=nstar
y[2,*]=ccdtemp & y[3,*]=bk
y[4,*]=encra   & y[5,*]=elong
y[6,*]=alt     & y[7,*]=theta
ytit=["FWHM (arcsec)","number of stars","temperature (celsius)","backgroud (ADU/s)","ENCRA ("+cgsymbol('deg')+")","star elongation","ALT ("+cgsymbol('deg')+")","position angle ("+cgsymbol('deg')+")"]
yran=fltarr(2,8)
yran[*,0]=[   2,   7] & yran[*,1]=[   0, 500]
yran[*,2]=[ -15,  05] & yran[*,3]=[   0, 550]
yran[*,4]=[-180, 180] & yran[*,5]=[   1, 1.2]
yran[*,6]=[  20,  80] & yran[*,7]=[ -90,  90]


cgdisplay,760,760
cgloadct,13
pos = cglayout([2,4], oxmargin=[7,7], oymargin=[5,7], xgap=0.5, ygap=0.5)
for o=0,7l do begin
  sym=sym1[o]
  cgplot,t,y[o,*],psym=sym,symsize=0.3,color='red',$
	xtit="local time (hour)",ytit=ytit[o],$
	xran=[16,32],yran=yran[*,o],$
	xthick=2.5,ythick=2.5,$
	xcharsize=([intarr(6)+1e-3,1,1])[o],$
	ycharsize=([1,1e-3,1,1e-3,1,1e-3,1,1e-3])[o],$
	xtickn=xtickn ,xticks=xticks,$
	noe=o NE 0, pos=pos[*,o],$
	xsty=1,ysty=1
  cgaxis,yaxis=1,ytit=ytit[o],ycharsize=([1e-3,1,1e-3,1,1e-3,1,1e-3,1])[o]
  cgaxis,xaxis=1,xtit="local time (hour)",xtickn=xtickn ,xticks=xticks,xcharsize=([1,1,intarr(6)+1e-3])[o]
  if o eq 2 then cgplot,t,tempam,psym=sym,symsize=symsize,color='blue',/overplot 
  p=[16.5,-10] 
  if o eq 2 then al_legend,['CCD','Environment'],/fill,psym=[2,2],colors=['red','blue'],box=1,pos=p
endfor
cgtext,0.5,0.95,string(yy[0],f='(i4)')+"/"+string(mm[0],f='(i2)')+"/"+string(dd[0],f='(i2)'),/normal,charsize=2.5,charthick=1.5,ALIGNMENT=0.5
saveimage,'fwhm.jpg',/jpeg, QUALITY=100,/quiet
;===fig2================================
x=fltarr(3,n)
y=fltarr(3,n)
x[0,*]=90-dec  & y[0,*]=-(ra+90)/180.*!pi
x[1,*]=-ra  & y[1,*]=dec
x[2,*]=-azi & y[2,*]=alt
z=t
color=bytscl(z)

cgdisplay,1200,600
pos = cglayout([2,2], oxmargin=[3,3], oymargin=[3,3], xgap=7, ygap=5)
plotsym,0,/fill
sym=8
symsize=1
;===fig2-1==============================
o=0
    ran=[-30,30]
    cgplot, x[o,*], y[o,*], /polar,xran=ran,yran=ran,$
       /nodata,pos=[pos[0,2],pos[1,2],pos[2,0],pos[3,0]],xsty=5,ysty=5, $
	   tit='Equatorial System',charsize=2
    cgplot, x[o,*], y[o,*], psym=-sym, color='blue',symsize=symsize,/over,/polar
    for k=0,n-1 do cgplot, x[o,k], y[o,k], psym=sym, color=color[k],symsize=symsize,/over,/polar
    cgplot, 90-dec20, -(ra20+90)/180.*!pi,psym=-3,color='dark grey',thick=2,/over,/polar
  al_legend,['Galactic latitude = 20'+cgsymbol('deg')],/fill,psym=[-3],colors=['dark grey'],box=1,thick=2
;===plot axis===
	for k=0,(90-65)/10 do cgPlotS, Circle(0, 0, (k+1)*10), Color='red',line=2
    cgplot,[0,0],ran,color='red',line=2,/over
    cgplot,ran,[0,0],color='red',line=2,/over
	for k=0,(90-65)/10+1 do cgtext,k*10/sqrt(2),k*10/sqrt(2),string(90-k*10,f='(i2)')+cgsymbol('deg'),ali=0.5,color='red'
    cgtext,0,ran[1]*0.95," 180"+cgsymbol('deg'),ali=0.5,color='black'
    cgtext,ran[1]*0.95,0," 270"+cgsymbol('deg'),ali=0.5,color='black'
    cgtext,0,ran[0]*0.95,"   0"+cgsymbol('deg'),ali=0.5,color='black'
    cgtext,ran[0]*0.95,0,"  90"+cgsymbol('deg'),ali=0.5,color='black'
;===fig2-2==============================
o=1
    cgplot, x[o,*], y[o,*], /nodata,pos=pos[*,1],/noe,xsty=5,ysty=5,tit='Equatorial System',charsize=2
    map_set,  0,  0,/AITOFF,/grid,/noe,pos=pos[*,1],color=fsc_color('black'),limit=[65,-180,90,180],/noborder
    cgplot , x[o,*], y[o,*], psym=-sym, color='blue',symsize=symsize,/over
    cgplots, x[o,*], y[o,*], psym=sym, color=color,symsize=symsize
    cgplot,-ra20,dec20,psym=-3,color='dark grey',thick=2,/over
	for k=1,7 do cgtext,45*k,75,string(360-k*45,f='(i3)')+cgsymbol('deg'),ali=0.5
	cgtext,0,75,string(0,f='(i3)')+cgsymbol('deg'),ali=0.5
	for k=0,(90-65)/10 do cgtext,0,90-k*10,string(90-k*10,f='(i2)')+cgsymbol('deg'),ali=0.5,color='red'
  al_legend,['Galactic latitude = 20'+cgsymbol('deg')],/fill,psym=[-3],colors=['dark grey'],box=1,thick=2
;===fig2-3==============================
o=2
    cgplot, x[o,*], y[o,*], /nodata,pos=pos[*,3],/noe,xsty=5,ysty=5,tit='Horizontal System',charsize=2
    map_set,  0,  0,/AITOFF,/grid,/noe,pos=pos[*,3],color=fsc_color('black'),limit=[40,-45,90,45],/noborder
    cgplot , x[o,*], y[o,*], psym=-sym, color='blue',symsize=symsize,/over
    cgplots, x[o,*], y[o,*], psym=sym, color=color,symsize=symsize
    cgplot,[0,0],[40,53.33],psym=-3,color='dark grey',thick=2,/over
	for k=1,7 do cgtext,45*k,75,string(360-k*45,f='(i3)')+cgsymbol('deg'),ali=0.5
	cgtext,0,75,string(0,f='(i3)')+cgsymbol('deg'),ali=0.5
	for k=0,(90-40)/10 do cgtext,0,90-k*10,string(90-k*10,f='(i2)')+cgsymbol('deg'),ali=0.5,color='red'
    al_legend,['ENCRA = '+cgsymbol('+-')+" 180"+cgsymbol('deg')],/fill,psym=[-3],colors=['dark grey'],box=1,thick=2

cgcolorbar,range=[min(z),max(z)],/v,pos=[pos[2,0]+0.03,pos[1,2],pos[2,0]+0.04,pos[3,0]]
cgtext,0.5,0.95,string(yy[0],f='(i4)')+"/"+string(mm[0],f='(i2)')+"/"+string(dd[0],f='(i2)'),/normal,charsize=2.5,charthick=1.5,ALIGNMENT=0.5
saveimage,'coor.jpg',/jpeg, QUALITY=100,/quiet
print,"median(fwhm)=",string(median(fwhm),f='(f0.1)')
print,"sigma(fwhm)=",string(sigma(fwhm),f='(f0.1)')
print,"median(backgroud)=",string(median(bk),f='(i4)')
g=where(elong gt 1.05,gn)
print,gn,n
cgdisplay,400,400
plothist,fwhm,/au,xtit="FWHM (pixal)",Ytit="N",TIT=string(yy[0],f='(i4)')+"/"+string(mm[0],f='(i2)')+"/"+string(dd[0],f='(i2)')+" FWHM Histogram"
saveimage,'fwhmhist.jpg',/jpeg, QUALITY=100,/quiet
end
