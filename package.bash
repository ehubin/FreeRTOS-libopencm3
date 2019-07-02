#!/usr/bin/bash -x

find='C:\Program Files\Git\usr\bin\find.exe'

TARGET_DIR="generatedLib" 
mkdir $TARGET_DIR

PREFIX="$1"
HEAP_FILE=heap_2.c
DIRLIST="
.
FreeRTOS
FreeRTOS/Source
FreeRTOS/Source/include
FreeRTOS/Source/portable
FreeRTOS/Source/portable/Common
FreeRTOS/Source/portable/MemMang
FreeRTOS/Source/portable/GCC/ARM_CM3"
for f in $DIRLIST
  do
  "$find" "$PREFIX/$f" -maxdepth 1 -type f -print | while IFS= read -r file; do
    target="${file%/*}"
    target="$TARGET_DIR/${target#"$PREFIX/"}"
    mkdir -p "$target" && cp $file "$target"
  done
done

# select memory policy
cd $TARGET_DIR/FreeRTOS/Source/portable/MemMang
for f in `ls *.c`
do
 if [ $f != $HEAP_FILE ]
 then
   mv $f "$f.off"
  fi
done
