#!/bin/sh

find . -iregex '.*\.sh$\|.*\.php$\|.*\.js$\|.*\.css$\|.*\.html$\|.*\.tpl$\|.*\.c$\|.*\.h$\|.*\.mk$' | xargs svn blame | awk '{print $2}' | sort | uniq -c | sort -n

