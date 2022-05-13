#!/bin/bash
set -eo pipefail

# This script initializes flaskbb for a new database.
# Whether or not initialization was already performed is determined by looking for the flaskbb role.

if ! psql --host postgres --username postgres --command='\du' --no-align --tuples-only | grep flaskbb > /dev/null
then
    echo -e "\033[0;34mCreate role flaskbb...\033[0m"
    psql --host postgres --username postgres --command='CREATE ROLE flaskbb WITH CREATEDB LOGIN' --echo-all

    echo -e "\033[0;34mRun flaskbb install...\033[0m"
    flaskbb install --username demo --password demo --email flaskbb@getbento.com

    echo -e "\033[0;34mInstall flaskbb plugins...\033[0m"
    flaskbb plugins install portal
fi

echo -e "\033[0;34mDone with init script.\033[0m"
