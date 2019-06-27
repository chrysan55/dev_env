if [ $# -ne 2 ];then
    echo "Usage: ./$0 BCNAT_IP BCNAT_VERSION"
fi

ip=$1
ver=$2

for eip in `/home/blb/common/tool/$ver/bcnatagent -b $ip --list-nat|grep eip |awk -F: '{print $2}'`
do
    /home/blb/common/tool/$ver/bcnatagent -b $ip -D -e $eip
done

for id in `/home/blb/common/tool/$ver/bcnatagent -b $ip --list-rlimit-group|grep group_id |awk -F: '{print $2}'`
do
    /home/blb/common/tool/$ver/bcnatagent -b $ip --del-rlimit-group -g $id
done
