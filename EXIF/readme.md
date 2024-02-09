Updates file creation time on JPG/jpg files with EXIF tag 0x9004(Date Time Digitized) or 0x9003 (Date Time Original) if 0x9004 is not present.

It could it be cleaner. Specfically getting the date stamp out of the exif. 
Does it work? Yes, at least for me on my system. 


Requires 'exif' package. 
