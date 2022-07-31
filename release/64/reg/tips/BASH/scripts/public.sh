#!/bin/sh
#filename:public.sh
#function:提供给各脚本公共接口
#
#
set -e 

dos2unix $0 >/dev/null 2>&1



###########函数名称
usage(){
    echo "Usage:$1"
    exit 1
}

#显示提示信息
showtips()
{
TIPS=$1
        if [ -z $TIPS];then
                echo "tips empty"
                exit 1
        fi
echo
echo "===================>>>>>$TIPS"
echo "===================>>>>>$TIPS"
echo "===================>>>>>$TIPS"
}


##文件夹/文件内容大小
lsinfo()
{
LSPATH=$1
echo "====>show lsinfo for [$LSPATH] begin"
echo "--->format man:"
ls -lh $LSPATH
echo "--->format size:"
ls -la $LSPATH
echo "--->format time:"
ls -lt $LSPATH
echo "====>show lsinfo for [$LSPATH] end"
echo
echo
}

# ==================文件夹操作
# ==================文件夹操作
# ==================文件夹操作
#检测文件夹是否存在或为空则退出
checkdirnoexistquit()
{
DIRPATH=$1
        if [ ! -d $DIRPATH ] || [ -z $DIRPATH ];then
                echo "dir [$DIRPATH] no exist!!!"
                exit 1
        fi
}

#检测文件夹不存在则创建
checkdirnoexistcreate()
{
DIRPATH=$1
        if [ ! -d $DIRPATH ];then
                echo "create dir [$DIRPATH]"
                mkdir $DIRPATH -p
        fi
}

#检测文件夹存在则退出
checkdirexistquit()
{
DIRPATH=$1
TIPS=$2
        if [ -d $DIRPATH ];then
                echo "dir [$DIRPATH] exist!!!"
                echo $TIPS
                exit 1
        fi
}

# ==================文件操作
# ==================文件操作
# ==================文件操作
#检测文件是否存在或为空则退出
checkfilenoexistquit()
{
FILEPATH=$1
FILEPATHTRIM=`echo $FILEPATH | xargs`

        if [ ! -f $FILEPATHTRIM ]  || [ -z $FILEPATHTRIM ];then
                echo "file [$FILEPATH] no exist!!!"
                exit 1
        fi
}

#检测文件存在则打印
checkfileexistquit()
{
FILEPATH=$1
TIPS=$2
        if [ -f $FILEPATH ];then
                echo "file [$FILEPATH] exist!!! " $TIPS
        fi
}




#软链接
softlink()
{
FILESRCPATH=$1
FILEDSTPATH=$2
TIPS="no process!!!"
	checkfilenoexistquit $FILESRCPATH
	# checkfileexistquit $FILEDSTPATH $TIPS
	if [ -f $FILEDSTPATH ];then
			echo "file [$FILEDSTPATH] exist!!! " $TIPS
	else
		ln -s $FILESRCPATH $FILEDSTPATH	
	fi
}

#软链接
softlink_write_dest_tobashrc()
{
BASHRCPATH=$1
FILESRCPATH=$2
FILEDSTPATH=$3
TIPS="no process!!!"

echo "BASHRCPATH:$BASHRCPATH"




	checkfilenoexistquit $FILESRCPATH
	checkfilenoexistquit $BASHRCPATH
	# checkfileexistquit $FILEDSTPATH $TIPS
	if [ -f $FILEDSTPATH ];then
			echo "file [$FILEDSTPATH] exist!!! " $TIPS
	else
		ln -s $FILESRCPATH $FILEDSTPATH	
	fi


	existflag=`cat $BASHRCPATH| grep -e "source $FILEDSTPATH" | wc -l`
	echo "existflag:$existflag"


	if [ 0 -eq $existflag ];then
		echo "no exist in $BASHRCPATH, then write"
		echo "dos2unix $FILEDSTPATH > /dev/null 2>&1" >> $BASHRCPATH
		echo "source $FILEDSTPATH > /dev/null 2>&1" >> $BASHRCPATH
	else
		echo "exist in $BASHRCPATH, no process !!!"
	fi
}



##查找所有
findlistall()
{
[ $# -lt 1 ] && usage "need 1 para"
DIRPATH=$1
checkdirnoexistquit $DIRPATH
cd $DIRPATH && find > findlist.all
}

#查找并忽略一些内容
findlistignore()
{
[ $# -lt 2 ] && usage "need 1 para"
DIRPATH=$1
IGNOREPATTERN="$2"
checkdirnoexistquit $DIRPATH
cd $DIRPATH && find | grep -v $IGNOREPATTERN > findlist.ignore
}

#查找并寻找所要的
findlistuse()
{
[ $# -lt 2 ] && usage "need 1 para"
DIRPATH=$1
FINDPATTERN="$2"
checkdirnoexistquit $DIRPATH
cd $DIRPATH && find | grep  $FINDPATTERN > findlist.grep
}