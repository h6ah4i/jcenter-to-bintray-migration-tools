#!/bin/bash -e

# ref.) https://issues.sonatype.org/browse/OSSRH-39405


# NOTE: Shares the same settings file with https://github.com/saket/startship,
# but it does not work because the tool expect the staging repository state open.

STARTSHIP_SETTINGS_FILE="$HOME/.gradle/gradle.properties"

SONATYPE_USER=$(cat "$STARTSHIP_SETTINGS_FILE" | grep 'SONATYPE_NEXUS_USERNAME=' | sed 's/.*=\(.*\)/\1/')
SONATYPE_PASSWORD=$(cat "$STARTSHIP_SETTINGS_FILE" | grep 'SONATYPE_NEXUS_PASSWORD=' | sed 's/.*=\(.*\)/\1/')

usage_exit() {
  echo "Usage: $0 -u SONATYPE_NEXUS_USER -p SONATYPE_NEXUS_PASSWORD bundle_jar" 1>&2
  exit 1
}

while getopts u:p:h OPT
do
    case $OPT in
        u)  SONATYPE_USER=$OPTARG
            ;;
        p)  SONATYPE_PASSWORD=$OPTARG
            ;;
        h)  usage_exit
            ;;
        \?) usage_exit
            ;;
    esac
done

shift $((OPTIND - 1))

if [[ "$SONATYPE_USER" = '' ]]; then
  echo 'User name is not specified' 1>&2
  usage_exit
fi

if [[ "$SONATYPE_PASSWORD" = '' ]]; then
  echo 'Password is not specified' 1>&2
  usage_exit
fi

BUNDLE="$1"

curl \
    --user "$SONATYPE_USER:$SONATYPE_PASSWORD" \
    --form "file=@$BUNDLE" \
    https://oss.sonatype.org/service/local/staging/bundle_upload
