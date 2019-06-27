cat /proc/net/bonding/bond1 | awk -F": " '
BEGIN {
	line="";
}
{
	if($1=="Slave Interface") {
		line=line"\n"$2;
	}
	if ($1=="Permanent HW addr") {
		line=line": "$2;
	}
}
END {
	printf "%s\n", line;
}'
