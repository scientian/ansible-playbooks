a=$(dpkg --list 'linux-image*'|awk '{ if ($1=="ii") print $2}'|grep -v `uname -r`)
for i in $a;
do
echo $i
apt-get -y purge $i;
continue;
done
apt-get -y autoremove
dpkg-reconfigure linux-image-`uname -a | awk '{print $3}'`
