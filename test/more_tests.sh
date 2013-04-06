
set -e

df -h | grep -q '^s3fs'
if [ $? -ne 0 ]; then
    echo "Did not find amounted s3fs filesystem"
    exit 1
fi

mkdir /tmp/dir1
mkdir -p /tmp/dir1/dir2/dir3
mkdir /tmp/dir1/dir2/dir3/dir4
echo file1 > /tmp/dir1/file
echo file1 > /tmp/dir1/dir2/dir3/file1
echo file2 > /tmp/dir1/dir2/dir3/file2
echo file3 > /tmp/dir1/dir2/dir3/dir4/file3


cp -r /tmp/dir1 dir1
cp -r dir1 dir1.cp
diff -r dir1 dir1.cp

# this should be a silent failure
chown $USER dir1/dir2

LS=`ls dir1/dir2/dir3/dir4`
if [ "$LS" != "file3" ]; then
    echo "Directory contents not as expected"
    exit 1
fi

mv dir1 dir1.renamed
diff -r dir1.renamed dir1.cp


tar -cvf dir1.tar ./dir1.renamed
cat dir1.tar dir1.tar dir1.tar dir1.tar >dir2.tar
cat dir2.tar dir2.tar dir2.tar dir2.tar >dir1.tar
cp dir1.tar dir2.tar
cksum dir1.tar dir2.tar

truncate --size 0 dir2.tar
mv dir2.tar empty.tar

touch empty.tar
touch dir1.cp

rm -fr dir1.renamed dir1.cp
rm -rf /tmp/dir1

