#!/bin/sh
#backup.sh Used For Create archive To TVM Imgage File
#
#   Do Not Modify Any Changes!!!
#
#sh -x only for debug
#Param1: TVM Absolute Execute Path, "/opt/tvm"
#Param2: OutPut Image File Name "tvm_backup0928"

BAK_LOG="backup.log"

usage()
{
  echo "Usage: `basename $0` /tvm/absolute/path ImageOutFile"
}

log()
{
  echo "$1" >>$BAK_LOG
}

faillog()
{
  log $1
  echo "$1"
  exit 1
}

touch_dir()
{
    if test ! -d $1
    then
        mkdir -p $1 2
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
TVM_DIR=`echo $WORK_DIR |awk -F/ '{print $NF}'` 
CUR_DIR=`pwd`
OUT_FILE=`echo $2 | awk 'BEGIN{FS="/"} {print $NF}'`
BAK_LOG="$CUR_DIR/tvm_backup_$OUT_FILE.log"

IMAGE_TEST=`echo $2 | awk '{ printf index($0, "/")}'`
if [ $IMAGE_TEST -ne 0 ]
then
   IMAGE_DIR=`echo $2 | awk 'BEGIN{FS="/"} ORS="/" {for (i=1; i <NF; i++) print $i}'`
else   
   IMAGE_DIR="$WORK_DIR/update/export"
fi


LOG_DIR="$WORK_DIR/update/export"
DATE_LAB=`date +%Y-%m-%d_%T`

#echo $WORK_DIR $TVM_DIR $OUT_FILE $BAK_LO
log "=========== Start Export TVM at $DATE_LAB ==========="
log "Work Directory: $WORK_DIR"
log "Object File Name: $OUT_FILE"

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

log "Delete Tar File: $OUT_FILE"
rm -f $OUT_FILE

tar cf $OUT_FILE $TVM_DIR/*.sh $TVM_DIR/tvm $TVM_DIR/conf/*.ini $TVM_DIR/dll $TVM_DIR/web $TVM_DIR/update/*.sh 
if [ $? -ne 0 ]
then
   faillog "Fail to Create Tar File: $OUT_FILE!"
else
   log "Create Tar File: $OUT_FILE Sucessfully!"
fi

touch_dir $IMAGE_DIR
mv $OUT_FILE $IMAGE_DIR 
if [ $? -ne 0 ]
then
  faillog "Fail to Move Tar File To Directory:$IMAGE_DIR!"
else
  log "Move Tar File to Directory: $IMAGE_DIR" 
fi

log "================= Export TVM File END ==============="
log ""

touch_dir $LOG_DIR
mv $BAK_LOG $LOG_DIR

#pwd

cd $CUR_DIR 

#Send Result back to tvm
echo "1"

