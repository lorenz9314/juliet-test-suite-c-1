#!/bin/bash


copyIncludes() {
    local INCLUDES=`grep "#include"  "$1" | grep -v "#include <" | grep -v '"std_' | grep -v '"testcases.h"' | sed -e 's/#include "//g' -e 's/".*$//g'`
    local DIR=`dirname $1`

    cp $1 $2

    for INCLUDE in $INCLUDES; do
      if [[ -z "${INCLUDE// }" ]]; then
        continue
      elif [ -f "$DIR/$INCLUDE" ]; then
        copyIncludes "$DIR/$INCLUDE" $2
      else
        echo "Cannot find $INCLUDE used in $1"
      fi
    done
}

OUTPUT=rearranged

mkdir -p $OUTPUT

for FILE in `grep -lr "int main" .`; do 
  CASE=${FILE%.*}
  DESTINATION="$OUTPUT/$CASE"

  mkdir -p "$DESTINATION"

  cp testcasesupport/* $DESTINATION
#  cp $FILE $DESTINATION

  copyIncludes $FILE $DESTINATION

#  echo $CASE 
done