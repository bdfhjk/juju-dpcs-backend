#!/bin/bash
#####################################################################
#
# Deploy demo
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
done 

# Check install of all dependencies
bash::lib::log debug Validating dependencies
bash::lib::ensure_cmd_or_install_package_apt git git-all

# Switching to project 
juju::lib::switchenv "${PROJECT_ID}" 

# Compute Slave Constraints
CONSTRAINTS=""
case "${ENABLE_GPU}" in
	"0" )
		bash::lib::log info Not using GPU for this deployment
		CONSTRAINTS="mem=4G cpu-cores=2 root-disk=${LOG_STORAGE}G"
	;;
	"1" )
		case "${CLOUD}" in 
			"aws" )
				bash::lib::log info Using GPU for this deployment
				CONSTRAINTS="instance-type=g2.2xlarge root-disk=${LOG_STORAGE}G"
				;;
			"azure" ) 
				bash::lib::log warn GPU not enabled on Azure, switching back to no GPU
				ENABLE_GPU=0
				CONSTRAINTS="mem=4G cpu-cores=2 root-disk=${LOG_STORAGE}G"
				;;
			"local" )
				bash::lib::log warn GPU not enabled on LXD
				ENABLE_GPU=0
				CONSTRAINTS="mem=4G cpu-cores=2 root-disk=${LOG_STORAGE}G"
				;;
		esac
	;;
	* )
	;;
esac

#####################################################################
#
# Deploy Apache Hadoop
#
#####################################################################
## Deploy HDFS Master
juju::lib::deploy apache-hadoop-hdfs-master hdfs-master "mem=4G cpu-cores=2 root-disk=32G"

## Deploy YARN 
juju::lib::deploy apache-hadoop-yarn-master yarn-master "mem=2G cpu-cores=2"

## Deploy Compute slaves
juju::lib::deploy apache-hadoop-compute-slave compute-slave "${CONSTRAINTS}"

juju::lib::add_unit compute-slave 2

## Deploy Hadoop Plugin
juju::lib::deploy apache-hadoop-plugin plugin

## Manage Relations
juju::lib::add_relation yarn-master hdfs-master
juju::lib::add_relation compute-slave yarn-master
juju::lib::add_relation compute-slave hdfs-master
juju::lib::add_relation plugin yarn-master
juju::lib::add_relation plugin hdfs-master

#####################################################################
#
# Deploy Apache Spark 
#
#####################################################################

# Services
juju::lib::deploy apache-spark spark "mem=2G cpu-cores=2"

# Relations
juju::lib::add_relation spark plugin

#####################################################################
#
# Deploy Apache Zeppelin
#
#####################################################################

# Services
juju::lib::deploy apache-zeppelin zeppelin

# Relations
juju::lib::add_relation spark zeppelin

# Exposition
juju::lib::expose zeppelin

#####################################################################
#
# Deploy iPython Notebook for Spark
#
#####################################################################

# Services
juju::lib::deploy apache-spark-notebook ipython-notebook

# Relations
juju::lib::add_relation spark ipython-notebook

# Exposition
juju::lib::expose ipython-notebook

#####################################################################
#
# Deploy rsyslog server for Log Aggregation
#
#####################################################################

# Services
#juju::lib::deploy rsyslog rsyslog-1
# juju::lib::deploy rsyslog rsyslog-2

#juju::lib::expose rsyslog-1
# juju::lib::expose rsyslog-2
#bash::lib::log info Rsyslog Servers will soon be available on their public IPs
# TBD: add computing the IP address / hostname in the library

#####################################################################
#
# Deploy Flume for Log Aggregation
#
#####################################################################

# Services
juju::lib::deploy apache-flume-hdfs flume-hdfs
juju::lib::deploy apache-flume-syslog flume-syslog

# Relations
juju::lib::add_relation flume-hdfs plugin
juju::lib::add_relation flume-hdfs flume-syslog
# juju::lib::add_relation flume-hdfs rsyslog-1

bash::lib::log info Zeppelin will soon be available on $(juju::lib::get_service_info zeppelin)
bash::lib::log info iPython Notebook will soon be available on $(juju::lib::get_service_info ipython-notebook)

