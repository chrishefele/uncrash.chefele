# pdf-to-png.sh 
#
# Converts a pdf file to a png file (obviously!)
# 
# usage:  pdf-to-png.sh file-input.pdf file-output.png
#
# Density is dots per inch (150 or 300 dpi common for print)
# Quality is for compression (100 uncompressed best image, 0 worst)

inputPDF=$1
outputPNG=$2
DPI=300
quality=100

echo Reading PDF ${inputPDF}
echo Writing PDF ${outputPNG}

convert -density ${DPI} ${inputPDF} -quality ${quality} ${outputPNG}


