#!/bin/sh
#upgrad.sh Used For Update TVM Imgage File
#
#   Do Not Modify Any Changes!!!
#
#sh -x only for debug
#Param1: TVM Absolute Execute Path, "/opt/tvm"
#Param2: OutPut Image File Name "/path/tvm_backup0928"

UPG_LOG="upgrade.log"

usage()
{
  echo "Usage: `basename $0` /tvm/absolute/path /path/ImageOutFile"
}

log()
{
  echo "$1" >>$UPG_LOG
}

faillog()
{
  log "$1"
  echo "$1"
  mv $UPG_LOG $LOG_DIR
  exit 1
}

touch_dir()
{
    if test ! -d $1
    then
        mkdir -p $1 
        if [ $? -ne 0 ]
        then
            log "mkdir $1 fail"
        fi
    fi
}

if [ $# -ne 2 ]
then 
  usage
  exit 1
fi

#delete "/" 
WORK_DIR=`echo $1| awk '{len=length(); if(substr($0,len,1)=="/") {printf substr($0,1,len-1)} else {print $0}}'`
TVM_DIR=`echo $WORK_DIR |awk -F/ '{print $NF}'`   #是tvm程序所在的文件夹的名称，这里是tvm
CUR_DIR=`pwd`
UPDATE_FILE="$2"                  #刚上传的文件的文件路径
IMAGE_FILE=`echo "$UPDATE_FILE" | awk -F/ '{printf $NF}'`   #刚上传的文件的文件名
UPG_LOG="$CUR_DIR/tvm_upgrade_$IMAGE_FILE.log"

LOG_DIR="$WORK_DIR/update/import"
DATE_LAB=`date +%Y-%m-%d_%T`

#echo $WORK_DIR $TVM_DIR $OUT_FILE $BAK_LOG
log "=========== Start Upgrade TVM at $DATE_LAB ==========="
log "Work Directory: $WORK_DIR"
log "Object File Name: $UPDATE_FILE"

touch_dir $WORK_DIR

test -f $UPDATE_FILE
if [ $? -ne 0 ]
then
  faillog "Image File $UPDATE_FILE not exist!"
fi

#验证在上传的压缩包中含有可执行程序：/tvm/tvm。其中tar tvf $UPDATE_FILE 指列出压缩包中的文件名
tar tvf $UPDATE_FILE | grep "tvm/tvm" >/dev/null 2>&1
if [ $? -ne 0 ]
then
  faillog "Fail to Validate File: $UPDATE_FILE"
fi

\cp $UPDATE_FILE "$WORK_DIR/../"
if [ $? -ne 0 ]
then
  faillog "Fail to Copy File to directory: $WORK_DIR!"
fi

cd $WORK_DIR
if [ $? -ne 0 ]
then
  faillog "Fail to Enter directory: $WORK_DIR!"
fi

cd ..
if [ $? -ne 0 ]
then
  faillog "Fail to Enter Upper directory: $WORK_DIR!"
fi

#解压缩文件
tar xf $IMAGE_FILE
if [ $? -ne 0 ]
then
   faillog "Fail to Extract Tar File: $IMAGE_FILE!"
else
   log "Extract Tar File: $IMAGE_FILE Sucessfully!"
fi

log "Chown execute permission to directory $TVM_DIR!"
chmod -fR +x $TVM_DIR

rm -f $IMAGE_FILE

log "================= Upgrade TVM File END ==============="
log ""

touch_dir $LOG_DIR
mv $UPG_LOG $LOG_DIR

cd $CUR_DIR 

#Send Result back to tvm
echo "1"

