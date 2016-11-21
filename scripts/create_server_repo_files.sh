#!/usr/bin/env bash
# @author: Zoltan Paldi
# @date: 2016-11-20
# @file: create_server_repo_files.sh
# @description:
#   This script create a yum repository file for the server.
#
# @example:
#
#[base]
#name=CentOS-$releasever - Base
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
##baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
#gpgcheck=1

#set -e -o pipefail

# Variables
###############################################################################
REPO_FILE='/etc/yum.repos.d/CentOS-Mirror.repo'
MIRROR_URL='http://mirror.for.me.uk/centos'
RELEASE_VERSIONS='6'
ARCHITECTURES='i386 x86_64'
REPOSITORIES='base updates extras centosplus'
DISABLED='centosplus'

# Functions
###############################################################################
# Function: check_repo_file
function check_repo_file() {
  if [ -f $REPO_FILE ]; then
    echo "${REPO_FILE} is exists"
    exit 1;
  else
    echo "The file is missing"
  fi
}

# Function: create_repo_file
function create_repo_file() {
  for releasever in ${RELEASE_VERSIONS}; do
    for arch in ${ARCHITECTURES}; do
      for repo in ${REPOSITORIES}; do
        if [ "${arch}" == "i386" ]; then
          echo "[${repo}.${arch}]" >> $REPO_FILE
        else
          echo "[${repo}]" >> $REPO_FILE
        fi
        echo "name=CentOS-$releasever - $arch - $repo" >> $REPO_FILE
        echo '#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra' >> $REPO_FILE
        echo "baseurl=${MIRROR_URL}/$releasever/$repo/$arch/" >> $REPO_FILE
        echo 'gpgcheck=1' >> $REPO_FILE
        state=1
        for disable in ${DISABLED}; do
          if [ "${disable}" == "${repo}" ]; then
            state=0
          fi
        done
        echo "enabled=${state}" >> $REPO_FILE
        echo "gpgkey=${MIRROR_URL}/RPM-GPG-KEY-CentOS-$releasever" >> $REPO_FILE
        echo "" >> $REPO_FILE
      done
    done
  done
}

# Main
###############################################################################

check_repo_file

create_repo_file
