# conert-indentation-tabs.sh
#
# How to directly overwrite with 'unexpand' (spaces-to-tabs conversion)?
# http://stackoverflow.com/questions/1091824/how-to-directly-overwrite-with-unexpand-spaces-to-tabs-conversion


for a in *.h
do
  unexpand -t 2 $a >$a-notab
  mv $a-notab $a
done


