#!/bin/sh
die () {
	echo "$@" 1>&2
	exit 1
}

### NOTE: ############################################################"
### The below two variables specify the auto* versions
### periods should be escaped with backslash, for use by grep
want_autoconf_version='2\.61'
want_autoheader_version=$want_autoconf_version
### END NOTE #########################################################"


outfile=configure
configfile=configure.ac

want_autoconf_version_clean=`echo $want_autoconf_version | sed -e 's/\\\\//g'`
want_autoheader_version_clean=`echo $want_autoheader_version | sed -e 's/\\\\//g'`

test -d autoconf && test -f autoconf/$configfile && cd autoconf
test -f $configfile || die "Can't find 'autoconf' dir; please cd into it first"
autoconf --version | grep $want_autoconf_version > /dev/null
test $? -eq 0 || die "Your autoconf was not detected as being $want_autoconf_version_clean"
aclocal --version | grep '^aclocal.*1\.9\.6' > /dev/null
test $? -eq 0 || die "Your aclocal was not detected as being 1.9.6"
autoheader --version | grep '^autoheader.*'$want_autoheader_version > /dev/null
test $? -eq 0 || die "Your autoheader was not detected as being $want_autoheader_version_clean"
libtool --version | grep '1\.5\.22' > /dev/null
test $? -eq 0 || die "Your libtool was not detected as being 1.5.22"
echo ""
echo "### NOTE: ############################################################"
echo "### If you get *any* warnings from autoconf below you MUST fix the"
echo "### scripts in the m4 directory because there are future forward"
echo "### compatibility or platform support issues at risk. Please do NOT"
echo "### commit any configure script that was generated with warnings"
echo "### present. You should get just three 'Regenerating..' lines."
echo "######################################################################"
echo ""
echo "Regenerating aclocal.m4 with aclocal 1.9.6"
aclocal_opts="--force -I $LLVM_TOP/support/autoconf/m4"
cwd=`pwd`
if test -d $cwd/m4 ; then
  aclocal_opts="$aclocal_opts -I $cwd/m4"
fi
echo "command: aclocal $aclocal_opts"
aclocal $aclocal_opts || die "aclocal failed"
echo "Regenerating configure with autoconf $want_autoconf_version_clean"
autoconf --force --warnings=all -o ../$outfile $configfile || die "autoconf failed"
NUM_CONFIG_HEADERS=`grep AC_CONFIG_HEADERS $configfile | wc -l`
if test "$NUM_CONFIG_HEADERS" -gt 0 ; then
  cd ..
  echo "Regenerating config.h.in with autoheader $want_autoheader_version_clean"
  autoheader_opts="--warnings=all -I autoconf -I $LLVM_TOP/support/autoconf/m4"
  if test -d $cwd/m4 ; then
    autoheader_opts="$autoheader_opts -I $cwd/m4 autoconf/$configfile"
  fi
  autoheader $autoheader_opts || die "autoheader failed"
fi
exit 0
