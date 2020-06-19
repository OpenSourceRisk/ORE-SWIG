#!/bin/sh

# to be run from the root base
GITHUB_BASE=../github/qrmoreswig

for dir in QuantExt-SWIG OREData-SWIG OREAnalytics-SWIG
do
  echo Copying $dir
  find $dir -name '*i' -print0 | while read -d $'\0' file
  do
    cp $file $GITHUB_BASE/$file
  done

  find $dir -name 'CMakeLists.txt' -print0 | while read -d $'\0' file
  do
    cp $file $GITHUB_BASE/$file
  done

  find $dir -name '*.py' -print0 | while read -d $'\0' file
  do
    cp $file $GITHUB_BASE/$file
  done

  find $dir -name '*.java' -print0 | while read -d $'\0' file
  do
    cp $file $GITHUB_BASE/$file
  done

done
echo -------

cp -R cmake ${GITHUB_BASE}
cp News.txt ${GITHUB_BASE}
