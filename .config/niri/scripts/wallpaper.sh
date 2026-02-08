DIR=$1
file="$DIR/$(ls $DIR | sort -R | tail -1)"
swww img $file
