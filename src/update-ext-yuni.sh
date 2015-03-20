#!/bin/sh

# target relative folder where to move the libyuni's sources
# <dirname script filename>/${targetlocalpath}/
targetlocalpath="ext/"



echo "== libyuni source updater"
if [ "${1}" = "" ]; then
	echo
	echo "\033[31mplease provide a branch name or tag\033[m"
	echo "here is the list:"
	echo
	branches=`git ls-remote --heads http://git.iwi.me/yuni/yuni.git | cut -d '	' -f 2 | sed 's:refs/heads/::g'`
	tags=`git ls-remote --tags http://git.iwi.me/yuni/yuni.git | cut -d '	' -f 2 | sed 's:refs/tags/::g'`
	echo "branches:"
	for i in $branches; do
		echo "    ${i}"
	done
	echo "tags:"
	for i in $tags; do
		echo "    ${i}"
	done
	echo
	exit 1
fi


myrealpath()
{
	local rp=$(which realpath)
	if [ ! "${rp}" = "" ]; then
		realpath "$1"
	else
		[[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
	fi
}

if [ "${TMPDIR}" = "" ]; then
	TMPDIR="/tmp"
fi
branch="${1}"
date=`date +%Y%m%d-%H%M%S`
clonepath="${TMPDIR}/ext-yuni-${date}"
localdir=`dirname "$0"`
local=`myrealpath "${localdir}"`

echo "== local: ${local}"
echo "== tmppath: ${clonepath}"

mkdir -p "${clonepath}" && cd "${clonepath}"
out=$?
if [ "$out" -ne 0 ]; then
	echo "impossible to create the folder ${clonepath}"
	exit 1
fi

echo "== cloning remote repository"
git clone --depth=1 --branch "${branch}" 'http://git.iwi.me/yuni/yuni.git'
out=$?
if [ "$out" -ne 0 ]; then
	echo "impossible to clone the remote repository"
	rm -rf "${clonepath}"
	exit 1
fi

cd "${clonepath}/yuni"

rm -rf "${clonepath}/yuni/.git"
rm -rf "${clonepath}/yuni/src/samples/"
rm -rf "${clonepath}/yuni/docs/"

mv "${local}/ext/yuni" "${local}/ext/yuni-backup-${date}"

echo "== switching to yuni update"
mv "${clonepath}/yuni" "${local}/${targetlocalpath}/"

# cleanup
echo "== cleanup"
#rm -rf "${local}/ext/yuni-backup-${date}"
rm -rf "${clonepath}"

echo "== done"
