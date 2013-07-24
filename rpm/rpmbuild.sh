#!/bin/bash

# 'rpmbuild.sh'.


# See below for usage.


set -e
set -u


# Error handling.
die () {
  echo "Error:  $*" > /dev/stderr
	exit 1
}

trap '{ die "An error occurred in rpmbuild.sh" }' err


# Usage.
usage () {
	cat <<-eof
Usage:
rpmbuild.sh options

Where options are:
--specfile specfile             - Path to rpm spec file.  Required.
--topdir topdir                 - Path to rpm top directory.  Required.
--sourcedir sourcedir           - Path to source directory.  Required.
--suffix suffix                 - Suffix to append to rpm name.  Optional.
--version version               - 'x.y.z' style rpm version.  Required.
--release release               - 'r' style rpm release number.  Required.
--project project			- name of the project (usually repository name). Required.


Example Jenkins build step for mageplus :

rpm/rpmbuild.sh \
	--specfile $WORKSPACE/rpm/mageplus.spec \
	--topdir /tmp/topdir/$JOB_NAME \
	--sourcedir $WORKSPACE \
	--version 1.7.0 \
	--release $BUILD_NUMBER \
	--suffix local
	-- project mageplus
  
This will output a package named mageplus-app-<$project>-<$suffix>-<$version>-<$release>.x86_64.rpm
}


# Parse command line.
[ $# -eq 0 ] && usage && exit 0
[ $# -eq 1 -a "${1:-}" = "--help" ] && usage && exit 0

# Defaults.
opt_suffix="%{nil}"

while [ $# -ge 2 ]; do
        eval opt_${1#--}=\"$2\"
        shift 2
done

for option in specfile topdir sourcedir version release; do
        v=opt_$option
	[ "${!v:-}" == "" ] && die "Missing option $option"
done


# Prepare.
for directory in BUILD RPMS SOURCES SPECS SRPMS; do
	mkdir -p $opt_topdir/$directory
done


echo
echo
echo "-- Build:"
rpmbuild -bb $opt_specfile \
	--define="_topdir $opt_topdir" \
	--define="opt_sourcedir `readlink -f $opt_sourcedir`" \
	--define="opt_suffix $opt_suffix" \
	--define="opt_version $opt_version" \
	--define="opt_release $opt_release" \
        --define="opt_project $opt_project" \

echo
echo
echo "-- Publish RPMs:"
for file in $opt_topdir/RPMS/*/*; do
	mv $file /vagrant/rpms/
done

echo
echo
echo "-- Cleanup:"
rm -rfv $opt_topdir


exit 0
