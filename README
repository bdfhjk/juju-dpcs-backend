#####################################################################
#
# Project Name: DPCS (Data Powered Crash Solver)
#
# Notes: https://launchpad.net/dpcs
# 
# Maintainer: Samuel Cozannet <samuel.cozannet@canonical.com> 
#
#####################################################################

# Purpose of the project
## Introduction 
This project is about creating an intelligent agent, running on Ubuntu based OSes, that analyzes in real time the status of the system and informs the user when some goes wrong or is about to go wrong. 

Instead of relying on a traditional server/agent mechanism, which would potentially pose privacy and legal issues, this intelligent agent is powered by an off line deep learning training, thanks to users willingly sharing their device information and logs and status from their machines. 
This deep learning training creates a "pre trained model", that is valid to run locally on all devices. While the binary of the agent remains the same, the configuration given by the pre trainined model can evolve. 

The agent therefore runs locally on any Ubuntu machine, without sharing information with the rest of the world, making it a privacy safe monitoring system. Users can then select what and how they share to help improve the intelligence of the system. 

This project is a collaboration between Canonical (the company behind Ubuntu) and the University of Warsaw. The project for the agent itself is on [Launchpad](https://launchpad.net/dpcs)

## Deep Learning Stack

While the agent is the core of the project and will be what people use on their machines, DPCS is also about sharing an example of architecture providing: 

* A log data pipeline sending logs to Hadoop from many machines
* An evolutive data computation stack, made of Spark, Hadoop, Kafka and other components from traditional big data stacks. 
* Coding interface is provided by [Zeppelin](https://www.zeppelinhub.com/), a fantastic programming interface provided by our friends and partners at [NFLabs](http://www.nflabs.com)

The whole system is modelled via [Juju](https://jujucharms.com), Canonical's Application Modelling Framework. 
The deployment is run on GPU enabled machines, either on AWS or on Bare Metal. 

This project will provide guidance about how you can deploy your own machine/deep learning stack at scale and do your own data analysis. We hope it will be useful for other universities and students to get their hands on classic big data infrastructure in just minutes. 

# This looks fun! Can I help? 

Indeed, any help is appreciated. In an upcoming commit, we will share an installation script that can be run on any Ubuntu Instance, and that installs key components to share your logs and configuration files with the programmers. 
We also welcome seasoned or new Machine Learning and Deep Learning engineers to participate in the project and help us. 

Over time, there is a good chance more components will be added to the project (GUIs, web pages with stats...). Help and ideas about how this could move forward are very welcome. Feel free to reach out to me for more information. 

At last, this will be a .deb package to install on your machines. Admins willing to help with the packaging and other goodness are of course more than welcome to join as well. 

# Usage
## I want to share my data to improve DPCS

TBC: 
* Terms & Conditions
* Install script for Fluent / rsyslog and configuration file collection (sos report)
* Deb package / ppa 

## I want to run my personal data collecion stack

You are very welcome to do so, and we'd love your feedback about the solution and how it behaves. 

### Pre requisites 
#### Downloading the repository

First clone the repo 

    git clone --recursive https://github.com/SaMnCo/juju-dpcs-project dpcs

Then create a configuration file from the template

    cd dpcs 
    cp ./etc/project.conf.template ./etc/project.conf

#### Juju Client 

In order to run the stack, you need to install the Juju client on your laptop. Instructions for Ubuntu, Windows and OS X are available [here](https://jujucharms.com/get-started)

#### Cloud Credentials

The installation of the Juju client has a wizard to connect to your favorite cloud. For this project, we advise the use of GPU machines, which are currently available only on AWS or Azure. 

* For AWS: TBC
* For Azure: TBC

Then use the cloud name you gave to configure the etc/project.conf file

#### Sizing your cluster

The idea here is to find out how much storage you'll need, depending on how many machines you want to analyse and for how long. Here are a few examples: 
Note that Hadoop is meant to scale, so this is really the first iteration, and will give us a unit of storage. If you reach the limit, you'll just have to add nodes. 

* Standard Usage: Counting 1M/day/laptop should be OK
    * 1 machine, 1 year: 365M
    * 10 machines, 1 year: 4G
    * 100 machines, 1 year: 40G

* In an intensive web server taking loads of hits, this may grow to 
say 50MB log data per day, so you have 
    * 1 machine, 1 year: 18G
    * 10 machines, 1 year: 183G
    * 100 machines, 1 year: 1.8T

In absolute madness, you could have ~1GB/raw log/day
    * 1 machine, 1 year: 365G
    * 10 machines, 1 year: 3.7T
    * 100 machines, 1 year: 37T

Eventually, have a look at your own logs, and find how much you generate per day. On Ubuntu, logs are stored in the /var/log folder, and you'll need sudo access. 

Use the number you found to configure the LOG_STORAGE line in the etc/project.conf file.

#### GPU or No GPU

This is really about your money. GPU machines on AWS are typically 5x more expensive than the others. So you may want to reduce the cost, at the expense of the speed of computation, or not. It's really up to you. 

### Deploying the stack

As a normal user, on Ubuntu, run: 

    cd /path/to/dpcs/project
    ./bin/00-bootstrap.sh

This will make sure your Juju environment is up & running

Then install with 

    ./bin/01-deploy.sh

Then... wait for a few minutes! 

#### Configuration

Edit ./etc/demo.conf to change: 

* PROJECT_ID : This is the name of your environment
* FACILITY (default to local0): Log facility to use for logging demo activity
* LOGTAG (default to demo): A tag to add to log lines to ease recognition of demos
* MIN_LOG_LEVEL (default to debug): change verbosity. Only logs above this in ./etc/syslog-levels will show up

## Bootstrapping 

	./bin/00-bootstrap.sh

Will set up the environment 

## Deploying  

	./bin/01-deploy.sh

Will deploy the charms required for the demo

## Configure  

	./bin/10-setup.sh

Will configure whatever needs to be configured

## Resetting 

	./bin/50-reset.sh

Will reset the environment but keep it alive

## Clean

	./bin/99-cleanup.sh

Will completely rip of the environment and delete local files

# Sample Outputs
## Bootstrapping

    :~$ ./bin/00-bootstrap.sh 
    Sourcing /home/scozannet/Documents/src/projects/dpcs/bin/../etc/project.conf
    Sourcing /home/scozannet/Documents/src/projects/dpcs/bin/../lib/00_bashlib.sh
    Sourcing /home/scozannet/Documents/src/projects/dpcs/bin/../lib/dockerlib.sh
    Sourcing /home/scozannet/Documents/src/projects/dpcs/bin/../lib/gcelib.sh
    Sourcing /home/scozannet/Documents/src/projects/dpcs/bin/../lib/jujulib.sh
    [dom mar 6 18:13:51 CET 2016] [dpcs] [local0.debug] : Validating dependencies
    [dom mar 6 18:13:51 CET 2016] [dpcs] [local0.debug] : Successfully switched to ml
    ^T[dom mar 6 18:19:04 CET 2016] [dpcs] [local0.debug] : Succesfully bootstrapped ml
    [dom mar 6 18:19:18 CET 2016] [dpcs] [local0.debug] : Successfully deployed juju-gui to machine-0
    [dom mar 6 18:19:20 CET 2016] [dpcs] [local0.info] : Juju GUI now available on https://X.X.X.X.X with user admin:password
    [dom mar 6 18:19:20 CET 2016] [dpcs] [local0.debug] : Bootstrapping process finished for ml. You can safely move to deployment.

## Deployment

    :~$ ./bin/01-deploy.sh 
    Sourcing /home/scozannet/Documents/src/projects/dpcs/bin/../etc/project.conf
    Sourcing /home/scozannet/Documents/src/projects/dpcs/bin/../lib/00_bashlib.sh
    Sourcing /home/scozannet/Documents/src/projects/dpcs/bin/../lib/dockerlib.sh
    Sourcing /home/scozannet/Documents/src/projects/dpcs/bin/../lib/gcelib.sh
    Sourcing /home/scozannet/Documents/src/projects/dpcs/bin/../lib/jujulib.sh
    [dom mar 6 18:20:38 CET 2016] [dpcs] [local0.debug] : Validating dependencies
    [dom mar 6 18:20:38 CET 2016] [dpcs] [local0.debug] : Successfully switched to ml
    [dom mar 6 18:20:38 CET 2016] [dpcs] [local0.info] : Not using GPU for this deployment
    [dom mar 6 18:20:58 CET 2016] [dpcs] [local0.debug] : Successfully deployed hdfs-master
    [dom mar 6 18:21:03 CET 2016] [dpcs] [local0.debug] : Successfully set constraints "mem=4G cpu-cores=2 root-disk=32G" for hdfs-master
    [dom mar 6 18:21:24 CET 2016] [dpcs] [local0.debug] : Successfully deployed yarn-master
    [dom mar 6 18:21:27 CET 2016] [dpcs] [local0.debug] : Successfully set constraints "mem=2G cpu-cores=2" for yarn-master
    [dom mar 6 18:21:43 CET 2016] [dpcs] [local0.debug] : Successfully deployed compute-slave
    [dom mar 6 18:21:46 CET 2016] [dpcs] [local0.debug] : Successfully set constraints "mem=4G cpu-cores=2 root-disk=500G" for compute-slave
    [dom mar 6 18:22:00 CET 2016] [dpcs] [local0.debug] : Successfully added 2 units of compute-slave
    [dom mar 6 18:22:06 CET 2016] [dpcs] [local0.debug] : Successfully deployed plugin
    [dom mar 6 18:22:08 CET 2016] [dpcs] [local0.debug] : Successfully created relation between yarn-master and hdfs-master
    [dom mar 6 18:22:09 CET 2016] [dpcs] [local0.debug] : Successfully created relation between compute-slave and yarn-master
    [dom mar 6 18:22:11 CET 2016] [dpcs] [local0.debug] : Successfully created relation between compute-slave and hdfs-master
    [dom mar 6 18:22:12 CET 2016] [dpcs] [local0.debug] : Successfully created relation between plugin and yarn-master
    [dom mar 6 18:22:13 CET 2016] [dpcs] [local0.debug] : Successfully created relation between plugin and hdfs-master
    [dom mar 6 18:22:26 CET 2016] [dpcs] [local0.debug] : Successfully deployed spark
    [dom mar 6 18:22:29 CET 2016] [dpcs] [local0.debug] : Successfully set constraints "mem=2G cpu-cores=2" for spark
    [dom mar 6 18:22:30 CET 2016] [dpcs] [local0.debug] : Successfully created relation between spark and plugin
    [dom mar 6 18:22:37 CET 2016] [dpcs] [local0.debug] : Successfully deployed zeppelin
    [dom mar 6 18:22:38 CET 2016] [dpcs] [local0.debug] : Successfully created relation between spark and zeppelin
    [dom mar 6 18:22:39 CET 2016] [dpcs] [local0.debug] : Successfully exposed zeppelin
    [dom mar 6 18:22:44 CET 2016] [dpcs] [local0.debug] : Successfully deployed ipython-notebook
    [dom mar 6 18:22:45 CET 2016] [dpcs] [local0.debug] : Successfully created relation between spark and ipython-notebook
    [dom mar 6 18:22:46 CET 2016] [dpcs] [local0.debug] : Successfully exposed ipython-notebook
    [dom mar 6 18:22:58 CET 2016] [dpcs] [local0.debug] : Successfully deployed flume-hdfs
    [dom mar 6 18:23:10 CET 2016] [dpcs] [local0.debug] : Successfully deployed flume-syslog
    [dom mar 6 18:23:11 CET 2016] [dpcs] [local0.debug] : Successfully created relation between flume-hdfs and plugin
    [dom mar 6 18:23:12 CET 2016] [dpcs] [local0.debug] : Successfully created relation between flume-hdfs and flume-syslog
    [dom mar 6 18:23:16 CET 2016] [dpcs] [local0.info] : Zeppelin will soon be available on X.X.X.X:9090
    [dom mar 6 18:23:16 CET 2016] [dpcs] [local0.info] : iPython Notebook will soon be available on X.X.X.X:8080


## Reset

    :~$ ./bin/50-reset.sh 
    [Thu Aug 27 14:09:57 CEST 2015] [financedemo] [local0.debug] : Successfully switched to quasardb
    [Thu Aug 27 14:12:22 CEST 2015] [financedemo] [local0.debug] : Successfully reset quasardb

