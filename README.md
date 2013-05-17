ClearCase Helper
================

ClearCase Helper is a small command line utility to make some aspects of ClearCase more accessible.

It originated from the wish to use a distributed version control system (hg, git) as the primary VCS and the need to update the clearcase repository in regular intervals.

Clearcase Helper wraps cleartool and builds upon its command set some new ones.
These commands especially allow you to add, remove, checkout hijacked and checkin files in a recursive manner.
Additionally you can view the status of the view files in a familiar way and add labels (tag) a bunch of files in one go.

By default files and directories that match .hg*, .svn* and .git* are ignored by all operations.
To control this behaviour it is possible to supply a .ccignore file with regexp patterns for files/directories that should be ignored.

Beware that ClearCase Helper is only an addition to the clearcase toolchain and not a substitute.


Install
-------

    gem install clearcase_helper


Usage
-----

    cch help

To recursively ignore some files, it is possible to create a .ccignore file with regexp patterns ([ruby Regexp](http://rubular.com)).
.ccignore files are only evaluated in the current working directory of cch.

Prerequesites
------------

  - cleartool
  - ruby 1.9.2
  - a snapshot view

Tested with cleartool version 7.1.1.2 on Windows 7 with ruby 1.9.2p0.


Build
-----

    rake build # this creates the gem in pkg/
    rake install # this task creates and installs the gem


Licence
-------

See LICENSE