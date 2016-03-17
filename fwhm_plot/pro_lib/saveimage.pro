;pro saveimage,file,quality=quality,dither=dither,cube=cube

;该函数用来保存图形对象

;DL> saveimage,'image.jpg'

;下面这个是辅助函数

function screenread,x0,y0,nx,ny,depth=depth

;check arguments

if (n_elements(x0) eq 0) then x0=0

if (n_elements(y0) eq 0) then y0=0

if (n_elements(nx) eq 0) then nx=!d.x_vsize-x0

if (n_elements(ny) eq 0) then ny=!d.y_vsize-y0



;check for TVRD capable device

tvrd_true=!d.flags and 128

if (tvrd_true eq 0) then message, $

'tvrd is not surported on this device:'+!d.name



;on devices which surpport windows,check for open window

win_true=!d.flags and 256

if (win_true gt 0) and (!d.window lt 0) then message, $

'No graphics window are open'



;get IDL version number

version=float(!version.release)



;get display depth

depth=8

if (win_true gt 0) then begin

if (version ge 5.1) then begin

device, get_visual_depth=depth

endif else begin

if (!d.n_colors gt 256) then depth=24

endelse

endif



;set decomposed color mode on 24-bit displays

if (depth gt 8) then begin

entry_decomposed=0

if (version gt 5.1) then $

device, get_decomposed=entry_decomposed

device,decomposed=1

endif



;get the contents of the windows

if (depth gt 8) then true=1 else true =0

image=tvrd(x0,y0,nx,ny,order=0,true=true)



;restore decomposed color mode on 24-bit displays

if (depth gt 8) then device, decomposed=entry_decomposed



;return results to caller

return,image

end





PRO SAVEIMAGE, FILE, $ 

  BMP=BMP, PNG=PNG, GIF=GIF, JPEG=JPEG, TIFF=TIFF, $ 

  QUALITY=QUALITY, DITHER=DITHER, CUBE=CUBE, QUIET=QUIET 

 

;- Check arguments 

if (n_params() ne 1) then $ 

  message, 'Usage: SAVEIMAGE, FILE' 

if (n_elements(file) eq 0) then $ 

  message, 'Argument FILE is undefined' 

if (n_elements(quality) eq 0) then quality = 75 

 

;- Get output file type 

output = 'JPEG' 

if keyword_set(bmp) then output = 'BMP' 

if keyword_set(png) then output = 'PNG' 

if keyword_set(gif) then output = 'GIF' 

if keyword_set(jpeg) then output = 'JPEG' 

if keyword_set(tiff) then output = 'TIFF' 

 

;- Check if GIF output is available 

version = float(!version.release) 

if (version ge 5.4) and (output eq 'GIF') then $ 

  message, 'GIF output is not available' 

 

;- Get contents of graphics window, 

;- and color table if needed 

image = screenread(depth=depth) 

if (depth le 8) then tvlct, r, g, b, /get 

 

;- Write 8-bit output file 

if (output eq 'BMP') or $ 

   (output eq 'PNG') or $ 

   (output eq 'GIF') then begin 

 

  ;- If image depth is 24-bit, convert to 8-bit 

  if (depth gt 8) then begin 

case keyword_set(cube) of 

  0 : image = color_quan(image, 1, r, g, b, $ 

        colors=256, dither=keyword_set(dither)) 

  1 : image = color_quan(image, 1, r, g, b, cube=6) 

endcase 

  endif 

 

  ;- Reverse PNG image order if required 

if (output eq 'PNG') and (version le 5.3) then $ 

image = reverse(temporary(image), 2) 

 

  ;- Save the image 

  case output of 

'BMP' : write_bmp, file, image, r, g, b 

'PNG' : write_png, file, image, r, g, b 

'GIF' : write_gif, file, image, r, g, b 

  endcase 

 

endif 

 

;- Write 24-bit output file 

if (output eq 'JPEG') or $ 

(output eq 'TIFF') then begin 

 

  ;- Convert 8-bit image to 24-bit 

  if (depth le 8) then begin 

info = size(image) 

nx = info[1] 

ny = info[2] 

true = bytarr(3, nx, ny) 

true[0, *, *] = r[image] 

true[1, *, *] = g[image] 

true[2, *, *] = b[image] 

image = temporary(true) 

  endif 

 

  ;- Reverse TIFF image order 

  if (output eq 'TIFF') then $ 

image = reverse(temporary(image), 3) 

 

  ;- Write the image 

  case output of 

'JPEG' : write_jpeg, file, image, $ 

            true=1, quality=quality 

'TIFF' : write_tiff, file, image, 1 

  endcase 

 

endif 

 

;- Report to user 

if (keyword_set(quiet) eq 0) then $ 

  print, file, output, $ 

format='("Created", a, " in ", a," format")' 

 

END 




