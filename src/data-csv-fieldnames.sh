for f in ../data/*.csv
do
    echo
    echo filename: $f 
    csvcut -n $f 
    echo
done

