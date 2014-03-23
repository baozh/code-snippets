#!/bin/sh
#
# usage: ./modify_file.sh ./
# 遍历一个目录下的所有子目录，将所有子目录中的文件中的内容（其实也是文件后缀名），从大写变小写
#


modify_file()
{
    cd $1
    for file in *;
	do
		if [ -f $file ]
		then
			cat $file | sed 's/\..*/\L&/g' > "$file"1
			mv -f "$file"1 $file
		fi
    done
}

# 递归遍历一个目录下的所有子目录 深度优先遍历
recusivefile()
{
	modify_file "./"
	
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


