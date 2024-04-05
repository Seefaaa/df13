#!/bin/bash
set -euo pipefail

tools/deploy.sh ci_test
mkdir ci_test/cfg
mkdir ci_test/data

#test config
cp tools/ci/ci_config.txt ci_test/cfg/config.txt

#set map
cp _maps/df_small.json ci_test/data/next_map.json

cd ci_test
DreamDaemon tgstation.dmb -close -trusted -verbose -params "log-directory=ci"
cd ..
cat ci_test/data/logs/ci/clean_run.lk
