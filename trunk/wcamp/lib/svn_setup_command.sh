#!/bin/sh
svn remove log/*
svn ci -m 'rm logfile'
svn up
svn propset svn:ignore "*.log" log/
svn ci -m 'ignore log/*.log'
svn up

svn remove db/development.sqlite3
svn ci -m 'rm development'
svn up
svn propset svn:ignore "*.sqlite3" db/
svn ci -m 'ignore db/*.sqlite3'
svn up

svn propset svn:ignore "*" tmp/cache/
svn propset svn:ignore "*" tmp/sessions/
svn propset svn:ignore "*" tmp/sockets/
svn propset svn:ignore "*" tmp/
svn ci -m "ignore tmp/*/*"
svn up
