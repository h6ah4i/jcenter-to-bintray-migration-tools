#!/bin/bash

set -euo pipefail

BUNDLE_JAR_FILENAME='bundle.jar'
FORCE_YES_MODE=0
VERBOSE=0
GPG_KEY_NAME=''

if [[ -v BUNDLE_JAR_GPG_KEY_NAME ]]; then
  GPG_KEY_NAME="$BUNDLE_JAR_GPG_KEY_NAME"
fi


usage_exit() {
  echo "Usage: $0 [-y] [-v] [-k gpg_key_name] target_dir" 1>&2
  echo "" 1>&2
  echo "     -y  No prompt mode." 1>&2
  echo "     -v  Verbose" 1>&2
  echo "     -k  Specify GPG key name" 1>&2
  exit 1
}

while getopts yvk:h OPT
do
    case $OPT in
        y)  FORCE_YES_MODE=1
            ;;
        v)  VERBOSE=1
            ;;
        k)  GPG_KEY_NAME=$OPTARG
            ;;
        h)  usage_exit
            ;;
        \?) usage_exit
            ;;
    esac
done

shift $((OPTIND - 1))

if [[ "$GPG_KEY_NAME" = "" ]]; then
  echo "GPG key name is not specified" 1>&2
  usage_exit
fi

TARGET_DIR="$1"

cd "$TARGET_DIR"

if [[ ("$FORCE_YES_MODE" -eq 0) && (-f "$BUNDLE_JAR_FILENAME") ]]; then
  read -n1 -p "Aye you sure to overwrite $BUNDLE_JAR_FILENAME? (y/N): " yn; [[ $yn = [yY] ]] && echo "" || exit 1
fi

GPG_CMD_FLAGS=''
XARGS_CMD_FLAGS=''
JAR_CMD_FLAGS='-cf'

if [[ "$VERBOSE" -eq 1 ]]; then
  JAR_CMD_FLAGS+="v"
  XARGS_CMD_FLAGS+=' --verbose'
  GPG_CMD_FLAGS+=' --verbose'
fi

if [[ "$FORCE_YES_MODE" -eq 1 ]]; then
  GPG_CMD_FLAGS+=' --yes'
fi

BULDLE_CONTENTS=$(find . \
  -maxdepth 1 \
  -type f \
  -not -name "$BUNDLE_JAR_FILENAME" \
  -not -name '*.md5' \
  -not -name '*.sha1' \
  -not -name '*.sha256' \
  -not -name '*.sha512' \
  -not -name '*.asc' \
  -not -name .DS_Store \
  -printf "%p\n" \
  )

BUNDLE_CONTENTS_WITH_ASC=$(echo "$BULDLE_CONTENTS" | sed  's/^\(.*\)$/\1\n\1.asc/g')

[[ "$VERBOSE" -eq 1 ]] && printf '\n>>> Sigining contents...\n'
echo "$BULDLE_CONTENTS" | xargs $XARGS_CMD_FLAGS -I@ gpg -u "$GPG_KEY_NAME" $GPG_CMD_FLAGS -ab @


[[ "$VERBOSE" -eq 1 ]] && printf '\n\n>>> Bundling...\n'
jar $JAR_CMD_FLAGS "$BUNDLE_JAR_FILENAME" $(echo "$BUNDLE_CONTENTS_WITH_ASC" | tr '\n' ' ')

[[ "$VERBOSE" -eq 1 ]] && printf '\n\n>>> FINISHED!\n'
