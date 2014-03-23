#!/bin/sh
#
# usage: ./rename.sh ./
# 遍历一个目录下的所有子目录，将所有子目录中的文件的后缀名，从大写变小写
#


renamefile()
{
    cd $1
    for file in *;
	do
		if [ -f $file ]
		then
			mv $file $(echo $file|sed 's/\..*/\L&/g')
		fi
    done
}

# 递归遍历一个目录下的所有子目录 深度优先遍历
recusivefile()
{
	renamefile "./"
	
	for dir in `ls .`
	do
	   if [ -d $dir ]
	   then
		 echo $dir
		 cd $dir
		 
		 recusivefile
		 cd ..
	   fi
	done
}


cd $1
recusivefile


