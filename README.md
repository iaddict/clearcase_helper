ClearCase Helper
================

ClearCase Helper is a small commanline utility to make some aspects of ClearCase more accessible.

It originated from the wish to use a ditsributed version control system (hg, git) as the primary VCS and the need to update the clearcase repository in regular intervals.

Clearcase Helper wraps cleartool and builds upon its command set some new ones.
Especially these commands allow you to add, remove, checkout hijacked and checkin files in recursive manner.


Install
-------

    gem install clearcase_helper


Usage
-----

    cch help


Prereqesites
------------

  - cleartool
  - ruby 1.9.2
  - a snapshot view

Tested with cleartool version 7.1.1.2 on Windows 7 with ruby 1.9.2p0.


Licence
-------

See LICENCE.txt