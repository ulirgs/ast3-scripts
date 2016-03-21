; $Id: //depot/InDevelopment/scrums/IDL_Kraken/idl/idldir/lib/julday.pro#1 $
;
; Copyright (c) 2012-2013, Exelis Visual Information Solutions, Inc. All
;       rights reserved. Unauthorized reproduction is prohibited.
;+
; NAME:
;	  GREG2JUL
;
; PURPOSE:
;	  Calculate the Julian Day Number for a given month, day, and year,
;	  using the proleptic Gregorian calendar.
;	  See also JUL2GREG, the inverse of this function.
;
;   CT, June 2012.
;-
;
pro jul2greg, julian, month, day, year, hour, minute, second

  compile_opt idl2

  ON_ERROR, 2		; Return to caller if errors
  CATCH, err
  if (err ne 0) then begin
    CATCH, /CANCEL
    MESSAGE, !ERROR_STATE.msg
  endif

  case N_PARAMS() of
    0: CALDAT, /PROLEPTIC
    1: CALDAT, julian, /PROLEPTIC
    2: CALDAT, julian, month, /PROLEPTIC
    3: CALDAT, julian, month, day, /PROLEPTIC
    4: CALDAT, julian, month, day, year, /PROLEPTIC
    5: CALDAT, julian, month, day, year, hour, /PROLEPTIC
    6: CALDAT, julian, month, day, year, hour, minute, /PROLEPTIC
    7: CALDAT, julian, month, day, year, hour, minute, second, /PROLEPTIC
  endcase
end

