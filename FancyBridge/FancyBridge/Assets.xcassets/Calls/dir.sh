count=48

for (( i=1; i<=$count; i++ ))
do  
   echo Card$i.imageset

    cp -R Call0.imageset Call$i.imageset
done