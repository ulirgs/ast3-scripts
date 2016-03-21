;+
;
;  NAME:
;    altsun2time 
;
;  PURPOSE:
;    Calculate Twilight Time's window, according to the data file 
;    created by altsun365.py.
;
;  OPTIONAL_INPUT:
;    file  - the data file created by altsun365.py (default='2016_altsun365.dat') 
;    d1    - a limit value of the sun altitude for twilight (default=-6) 
;    d2    - another limit value of the sun altitude for twilight (default=-9) 
;  
;  OUTPUT:
;    Standard output - the begin and end time of twilight in "Beijing" timezone.
; 
;  EXAMPLE:
;  IDL>altsun2time,file='2016_altsun365.dat',alt1=-9,alt2=-13
;
;      Begin:  2016-07-10T13:48:00
;      End  :  2016-07-10T16:06:00
;      Begin:  2016-07-11T13:37:00
;      End  :  2016-07-11T16:17:00
;      Begin:  2016-07-12T13:28:00
;      End  :  2016-07-12T16:26:00
;      Begin:  2016-07-13T13:19:00
;      End  :  2016-07-13T16:37:00
;
;   DEPENDENCIES:
;
;     Requires JUL2GREG from the IDL 8.2.1.
;-

pro altsun2time,file=file,alt1=alt1,alt2=alt2
;   DEFAULT VALUES AND ERROR CHECKING
if not keyword_set(file) then file = '2016_altsun365.dat' 
if not keyword_set(alt1) then alt1 = -6
if not keyword_set(alt2) then alt2 = -9

readcol,file,format='d,f,f,f,f',DJD, $
	sunAz, sunAlt ,moonAz ,moonAlt, mPhase

i_flat=where(sunAlt lt max([alt1,alt2]) and sunAlt gt min([alt1,alt2]))

DJD_flat=DJD(i_flat)
day_domea=DJD_flat - min(DJD) + 5/24.
noon_domea= day_domea mod 1

for o=0,365 - 1 do begin
	i_am=where(floor(day_domea) eq o and noon_domea lt 0.5)
	i_pm=where(floor(day_domea) eq o and noon_domea gt 0.5)
	if (i_am[0] ne -1) and (i_pm[0] ne -1) then begin
		date=[min(DJD_flat[i_am]) ,max(DJD_flat[i_am]) , $
			min(DJD_flat[i_pm]) ,max(DJD_flat[i_pm])]
		JUL2GREG, 2415020 + date + 8/24., M, D, Y, HH, MM
		note=['Begin:','End  :','Begin:','End  :']
		for p=0,3 do begin
			if (abs(((date[p] - min(DJD) + 5/24.) MOD 1) - 0.5 ) lt 0.5 - 1/24./60.*10.) $
				and $
				(abs(((date[p] - min(DJD) + 5/24.) MOD 1) - 0.5 ) gt 1/24./60.*10.) $
				then print,note[p],Y[p] ,M[p] ,D[p] ,HH[p] ,MM[p], $
				format='(A, I6,"-",I02,"-",I02,"T",I02,":",I02,":00")'
		endfor
	endif
endfor
end

