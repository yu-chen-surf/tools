#!/usr/bin/bash

set -x

project_dir=/data/test/fengwei/kvm_coco_snapshot

log_dir=/data/test/fengwei
logfile=$log_dir/test.log

upstream_kvm_url=https://git.kernel.org/pub/scm/virt/kvm/kvm.git
upstream_kvm_dir=$project_dir/kvm_upstream

tag_date=`date +%Y%m%d`
tag_name=kvm-coco-queue-snapshot/kvm-coco-queue-snapshot-$tag_date

echo `date +%Y%m%d` >> $logfile
if [ ! -d $upstream_kvm_dir ]; then
	git clone --branch kvm-coco-queue $upstream_kvm_url $upstream_kvm_dir
else
	cd $upstream_kvm_dir
	git fetch --all -t
	echo "git fetch $upstream_kvm_url successfully" >> $logfile
fi

if [ ! -d $upstream_kvm_dir ]; then
	echo "git clone $upstream_kvm_url failed" >> $logfile
	exit
else
	echo "git clone $upstream_kvm_url successfully" >> $logfile
fi

cd $upstream_kvm_dir
kvm_coco_queue_hash=`git show --pretty=%h remotes/origin/kvm-coco-queue | head -n 1`

# Get the current HEAD commit hash
current_head=$(git rev-parse --short HEAD)

echo "kvm_coco_queue_hash=$kvm_coco_queue_hash" >> $logfile
echo "current_head=$current_head" >> $logfile

# Compare the current HEAD with the given commit hash
if [ "$current_head" == "$kvm_coco_queue_hash" ]; then
    echo "The HEAD $current_head is up-to-date with kvm-coco-queue"
    exit
else
    echo "The HEAD $current_head is behind kvm-coco-queue $kvm_coco_queue_hash"
fi

echo "kvm-coco-queue has been updated on [2024-10-31] https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue" | /usr/local/bin/mutt -e 'set sendmail_wait=0' -e 'set use_from=yes' -e 'set realname="Chen Yu"' -s "[notify] kvm-coco-queue rebase detected." -n yu.c.chen@intel.com,yu.chen.surf@foxmail.com

# update the kvm-upstream to the latest
cd $upstream_kvm_dir

git merge master origin/kvm-coco-queue
