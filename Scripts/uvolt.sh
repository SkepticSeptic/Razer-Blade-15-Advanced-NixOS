# undervolting script
# to be safe, test this first or just adjust it to -50 instead of -100

sudo undervolt --core -100 --cache -100

echo 1 > ~/Scripts/uvolt-status # uvolt-status = 1, undervolting
