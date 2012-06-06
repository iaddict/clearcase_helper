ClearCase Helper
================

ClearCase Helper is a small commanline utility to make some aspects of ClearCase more accessible.

It originated from the wish to use a ditsributed version control system (hg, git) as the primary VCS and the need to update the clearcase repository in regular intervals.

Clearcase Helper wraps cleartool and builds upon its command set some new ones.
These commands expecially allow you to add, remove, checkout hijacked and checkin files in recursive manner.
Additionally you can view the status of the view files in a familiar way.

Files and directories that match .hg*, .svn* and .git* are ignored by all operations.

Beware that ClearCase Helper is only an adition to the clearcase toolchain and not a subtitute.


Install
-------

    gem install clearcase_helper


Usage
-----

    cch help


Prerequesites
------------

  - cleartool
  - ruby 1.9.2
  - a snapshot view

Tested with cleartool version 7.1.1.2 on Windows 7 with ruby 1.9.2p0.


Licence
-------

See LICENCE.txt