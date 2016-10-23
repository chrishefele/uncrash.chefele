
# Some of the .png screenshots use transparency instead of a white background
# so this script makes a new version with a white background.

for img in ../screenshots/raw/*.png 
do
    convert ${img} -background white -alpha remove ../screenshots/transparent-to-white/`basename ${img}`
done

