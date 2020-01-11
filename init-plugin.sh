#!/usr/bin/env bash

# This tool setup a new project in "How to add/create your own VST3 Plug-Ins"
# https://steinbergmedia.github.io/vst3_doc/vstinterfaces/addownplugs.html

if [ $# -ne 1 ] || [ $1 = "-h" ]; then
    echo "usage: $0 <CamelCaseName>"
    exit 1
fi
if [ -d $1 ]; then
    echo "./$1 already exists."
    exit 1
fi

cp -r $(dirname $0)/helloworld/ $1

echo "add_subdirectory($1)" >> CMakeLists.txt

grep -rl HelloWorld $1 | xargs sed -i "s/HelloWorld/$1/g"
grep -rl helloworld $1 | xargs sed -i "s/helloworld/${1,,}/g"
grep -rl "Hello World" $1 | xargs sed -i "s/Hello World/$1/g"


p=$(uuidgen | sed 's/-//g')
p=${p^^}
c=$(uuidgen | sed 's/-//g')
c=${c^^}

echo "static const FUID MyProcessorUID  (0x${p:0:8}, 0x${p:8:8}, 0x${p:16:8}, 0x${p:24:8});
static const FUID MyControllerUID (0x${c:0:8}, 0x${c:8:8}, 0x${c:16:8}, 0x${c:24:8});

//------------------------------------------------------------------------
} // namespace $1
} // namespace Steinberg" >> $1/include/plugids.h


echo "NOTE: you have to edit '$1/include/version.h' with your name/url/email/copyright!"
