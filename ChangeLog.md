# Change Log

ClearCase Helper is a small command line utility to make some aspects of ClearCase more accessible.

    gem install clearcase_helper
    cch help

## v0.5.0

* Fix: redone the way cleartool is called to slove escaping issues (fixes #4)
* Feature: new option --keep for checkin and checkin_hijacked command that keeps files checked out [thx @TyMi]
* improve .ccignore processing

## v0.4.10

* Fix: `cch st` should also be available as `cch status` [thx @TyMi]

## v0.4.9

* added .ccignore file support to control which files and directories should not be tracked [thx @TyMi]
* some gem build cleanups