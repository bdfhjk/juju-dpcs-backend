#!/bin/bash
#####################################################################
#
# Configure Demo
#
# Notes: 
# 
# Maintainer: Samuel Cozannet <samuel.cozannet@canonical.com> 
#
#####################################################################

# Validating I am running on debian-like OS
[ -f /etc/debian_version ] || {
	echo "We are not running on a Debian-like system. Exiting..."
	exit 1
}

# Load Configuration
MYNAME="$(readlink -f "$0")"
MYDIR="$(dirname "${MYNAME}")"
MYCONF="project.conf"

for file in $(find ${MYDIR}/../etc -name "${MYCONF}") $(find ${MYDIR}/../lib -name "*lib*.sh" | sort) ; do
	echo Sourcing ${file}
	source ${file}
	sleep 1
done 

# Check install of all dependencies

# Switching to project
juju::lib::switchenv "${PROJECT_ID}" 

# Now insert code 

