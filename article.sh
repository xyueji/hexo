#!/bin/bash

files=`ls`
dir="xyueji.github.io"
flag="-n"

printHelp(){
	echo "-f   文章"
	echo "-t   标签"
	echo "-c   文章分类"
	echo "-n   重建hexo"
	echo "-rm  删除文章"
	echo "-s   提交"
}

h="--help"
if [[ ${#} == 0 ]] || ([[ ${#} == 1 ]] && [[ ${1} == $h ]])
then
	printHelp
fi

flag="-n"
if [[ ${#} == 1 ]] && [[ ${1} == ${flag} ]]
then
	for file in $files
	do
	if [[ $file == $dir ]] 
	then
		rm -rf $dir
		break
	fi
	done
	git clone -b hexo https://github.com/xyueji/xyueji.github.io.git
	cd $dir
	npm install
	cd ..
fi

f="-f"
t="-t"
c="-c"
file=""
tags=""
categories=""
args=()
args[0]=${1}
args[1]=${2}
args[2]=${3}
args[3]=${4}
args[4]=${5}
args[5]=${6}

if [[ ${#} == 6 ]] && [[ ${@} =~ $f ]] && [[ ${@} =~ $t ]] && [[ ${@} =~ $c ]]
then
	for i in {0,1,2,3,4,5}
	do
		if [ ${args[i]} == $f ]
		then
			file=${args[i+1]}
		fi

		if [ ${args[i]} == $t ]
		then
			str=${args[i+1]//,/ }
			arr=($str)
			for tag in ${arr[@]}
			do
				tags=$tags"- "$tag"\\n"
			done
		fi

		if [ ${args[i]} == $c ]
                then
			str=${args[i+1]//,/ }
                        arr=($str)

                        for category in ${arr[@]}
                        do
                                categories=$categories"- "$category"\\n"
                        done
                fi
	done
date=`date +"%Y-%m-%d %H:%M:%S"`
file_name=${file%.*}

touch tmp.txt
echo -e "---\ntitle: "${file_name}"\ndate: "${date}"\ntags:\n"${tags}"\ncategories:\n"${categories}"\n---" > tmp.txt
cat $file >> tmp.txt
cat tmp.txt > $file
rm tmp.txt

cp ${file}.md $dir/source/_posts/
fi

submmit="-s"
if [[ ${#} == 1 ]] && [[ ${1} == $submmit ]]
then
	git checkout -b hexo
	cd $dir
	hexo d -g
	git push origin hexo
	cd ..
fi

delete="-rm"
if [[ ${#} == 2 ]] && [[ ${1} == $delete ]]
then
	rm $dir/source/_posts/${2}.md
fi	
