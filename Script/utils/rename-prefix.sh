for name in EDS*
do
  newname=SED"$(echo "$name" | cut -c4-)"
  mv "$name" "$newname"
done
