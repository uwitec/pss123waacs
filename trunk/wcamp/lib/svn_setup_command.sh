#!/bin/sh
svn remove log/*
svn ci -m 'rm logfile'
svn up
svn propset svn:ignore "*.log" log/
svn ci -m 'ignore log/*.log'
svn up

svn propset svn:ignore "*" tmp/cache/
svn propset svn:ignore "*" tmp/sessions/
svn propset svn:ignore "*" tmp/sockets/
svn propset svn:ignore "*" tmp/
svn ci -m "ignore tmp/*/*"
svn up
