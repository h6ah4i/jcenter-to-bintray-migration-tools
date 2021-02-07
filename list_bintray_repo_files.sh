#!/bin/bash -e
cd $(dirname $0)
ruby list_bintray_repo_files.rb "$1"
