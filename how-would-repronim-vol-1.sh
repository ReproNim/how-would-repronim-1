#!/bin/bash

if [ ! -e /var/run/docker.sock ]
then
    echo "/var/run/docker.sock not found in container" >&2
    exit 1
fi

run_dir_mount=$( docker inspect $( hostname ) \
                 | jq -r '.[0].HostConfig.Binds | .[]' \
                 | grep -v docker.sock )

if [ -z "$run_dir_mount" ]
then
    echo "no working directory mounted" >&2
    exit 1
fi

run_dir=$( echo "$run_dir_mount" | awk -F: '{print $2}' )
if [ "$( echo "$run_dir_mount" | awk -F: '{print $1}' )" != "$run_dir" ]
then
    echo "mounted directory must have the same path inside and outside the container" >&2
    exit 1
fi

echo "run directory is $run_dir"

cd $run_dir
if [ $( ls | wc -c ) -gt 0 ]
then
    echo "run directory is not empty" >&2
    exit 1
fi

cp /anat.nii.gz .
gunzip anat.nii.gz
cp /how-would-repronim-vol-1.ipynb .

exec jupyter notebook \
             --ip=0.0.0.0 \
             --allow-root \
             --no-browser \
             --NotebookApp.token=

# eof
