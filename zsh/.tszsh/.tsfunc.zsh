function shinchoku {

	arr=("twitter.com" "youtube.com" "nicovideo.jp" )

	for i in "${arr[@]}"
	do
		sudo sh -c "echo '127.0.0.1 "${i}"' >> /etc/hosts"
		echo "[ACCESS✕]:${i}"
	done
	sudo killall -HUP mDNSResponder
	echo "Press [Enter] to quit."
	read tmp
	for i in "${arr[@]}"
	do
		sudo sed -i "/"${i}"/d" /etc/hosts
	done
	sudo killall -HUP mDNSResponder

}

function mdir {
	mkdir $1 && cd $_
}

function cdp {
	local dir="$( ls -1d */ | peco )"
	if [ ! -z "$dir" ] ; then
		cd "$dir"
	fi
}

# プレゼンテーションモード
function stprsenmd {
	trap "
		defaults -currentHost write com.apple.screensaver idleTime -int $_idleTime
		dshow
		echo '\nhalted'
		" 1 2 3 15
	local _idleTime="$(defaults -currentHost read com.apple.screensaver idleTime)"
	dhide
	defaults -currentHost write com.apple.screensaver idleTime -int 0
	echo "Presentation mode has started. Press Ctr+C to quit."
	caffeinate
}

# vim を利用してファイルの中身までag
function agvim () {
	vim $(ag $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}

# usage
#
# $ <<something output to stdout>> | c
function c(){
	pbcopy && echo "Copy to Clipboard!"
}

# git utility
function g(){
	echo -e '\n\e[34m[RUN]\e[mPull from remote...' && git pull origin
	echo -e '\n\e[34m[RUN]\e[madd and commit '
	git add -A
	if [ ! $1 ]; then
		git commit -a -m 'add and change files(no comment)'
	else
		git commit -a -m $1
	fi
	echo -e '\n\e[34m[RUN]\e[mPush to remote...' && git push origin
}

# to run a C++ program
function a()
{
	g++ $1 -std=c++11 -Wall -O2
	if [ $? -eq 0 ]; then
		echo -e '\e[32m [Build Success] \e[m'
		./a.out
	fi
}

function peda()
{
	if [ -e ~/.gdbinit ]; then
		mv ~/.gdbinit ~/._gdbinit
		echo "gdb-peda is disabled."
	else
		mv ~/._gdbinit ~/.gdbinit
		echo "gdb-peda is enabled"
	fi
}

function dbg()
{
	g++ $1 -std=c++11 -g -O0 -o $1.out
	if [ $? -eq 0 ]; then
		echo -e '\e[32m [Build Success] \e[m'
		gdb $1.out
	fi
}

#terminalのバーのタイトルを変更
function title()
{

if [ "$#" -eq 0 ];then
	echo "usage tl name "
else
	echo -en "\033];$1\007"
fi
}


#### vagrant utils


function l2v (){
	cp $1 $local && echo "copied ${1} to ${local}"
}

function vsta () {
    local dir=`pwds`
    cd $local
    vagrant "${1:-status}"
    cd $dir
}

function vu(){
	cd $local
	vagrant up &&  vagrant ssh
}

function  nowplaying_tweet(){
	v=$(nowplaying)
	if [ -n $v ];then
		echo "Tweet: \n$v\n"
		read ans
		t tweet $v
	fi
}


function mk(){
	if [ "${1##*.}" = "cpp" ]; then
		# seems to be bad..
		echo "#include <bits/stdc++.h>\nusing namespace std;\nint main(){\n\n}">$1
	fi
}

# Finder utilities
function fshow(){
	defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder
}
function fhide(){
	defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder
}

# Desktop icon utilities
function dshow(){
	defaults write com.apple.finder CreateDesktop TRUE && killall Finder
}
function dhide(){
	defaults write com.apple.finder CreateDesktop FALSE && killall Finder
}

# related to alias for extract.
function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
  esac
}



# あんぽんたん => ｱﾝﾎﾟﾝﾀﾝ
function kana(){
	echo $1 |nkf --katakana | nkf -Z4

}

function oj-aoj(){
	~WORK/OJ/oj.py --aoj ${1%.*} -i $1 -c --setting-file-path ~WORK/OJ/setting.json
	echo "Want to submit the code? [Y/n]"
	read ANS
	case `echo $ANS | tr N n` in
    	"" | N* ) return ;;
	esac
	~WORK/OJ/oj.py --aoj ${1%.*} -i $1 -s
}

#
# utility functions for JOI
#
function joi(){
	#rm ./joi-$1
	g++ q$1.cpp -Wall -O2 -o joi-$1.out

	if [ $? -eq 0 ]; then
                 echo -e '\e[32m [Build Success] \e[m'
	          ./joi-$1.out
	fi

}

function run(){
	if [ $# -eq 1 ]; then
		zsh run.sh $1
	else
		echo 問題番号を指定して！
	fi
}


function diff_p(){
	if [ $# -eq 1 ]; then
		zsh diff.sh $1
	else
		echo 問題番号を指定して！
	fi
}
