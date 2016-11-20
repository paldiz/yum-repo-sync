#!/usr/bin/env bash
# @author: Zoltan Paldi
# @date: 2016-11-20
# @file: create_directory_hierarchy.sh
# @description:
#   This script create a hierarchy for yum repositories.
#
# @example:
#   BASE_DIR        : /var/www/html/centos/
#   RELEASE_VERSIONS: 6
#   ARCHITECTURES   : i386 x86_64
#   REPOSITORIES    : base updates
#
# Hierarchy:
#   /var/www/html/centos/6/
#   /var/www/html/centos/6/i386/
#   /var/www/html/centos/6/i386/base/
#   /var/www/html/centos/6/i386/updates/
#   /var/www/html/centos/6/x86_64/
#   /var/www/html/centos/6/x86_64/base/
#   /var/www/html/centos/6/x86_64/updates/

#set -e -o pipefail

# Variables
###############################################################################
BASE_DIR='/var/www/html/centos'
RELEASE_VERSIONS='6'
ARCHITECTURES='i386 x86_64'
REPOSITORIES='base updates'

# Functions
###############################################################################
# Function: is_root
function is_root() {
  user=$(whoami)
  uid=$(grep "^$user:" /etc/passwd | cut -d ":" -f3)

  if [ $uid -ne 0 ]; then
    echo 'This script requires root permissions or please use with sudo'
    echo "Example: sudo bash ${0##*/}"
    exit 1;
  fi
}


# Function: create_hierarchy
function create_hierarchy() {
  for releasever in ${RELEASE_VERSIONS}; do
    for arch in ${ARCHITECTURES}; do
      for repo in ${REPOSITORIES}; do
        mkdir -pv "${BASE_DIR}/${releasever}/${arch}/${repo}"
      done
    done
  done
}

# Main
###############################################################################

is_root

create_hierarchy
