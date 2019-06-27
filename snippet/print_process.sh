copy_process() {
        local src=$1
        local dst=$2
        local i=0
        local percent=0
        local arrow='=>'
        local sym=''
        local files=$(ls $src)
        local n_file=$(ls $src|wc -l)

        if [ -z "$files" ]; then
                echo "no such file or directory: $src"
                return 1
        fi

        for f in $files
        do
                if ! cp $f $dst > /dev/null 2>&1; then
                        echo "copy $f to $dst failed"
                        return 1
                fi
                ((i++))
                percent=$(($i*100/$n_file))
                sym=$(printf %.s= $(seq -s " " 1 $(($percent/2))))$arrow
                printf "progress: [%-52s]%d%%\r" $sym $percent
        done
        echo
}

