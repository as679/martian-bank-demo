#!/bin/bash
# Copyright (c) 2023 Cisco Systems, Inc. and its affiliates All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#######################################################################################
## Setup
function setup_env {
  rm -rf venv_locust
  rm -rf __pycache__

  python3 -m venv venv_locust
  source venv_locust/bin/activate
  pip install -r requirements.txt
}

#######################################################################################
## Running Locust
function runner {
  locust -f auth_locust.py --headless -u 1 -r 1 --run-time 10s
  sleep 2

  locust -f atm_locust.py --headless -u 1 -r 1 --run-time 6s
  sleep 2

  locust -f account_locust.py --headless -u 1 -r 1 --run-time 6s
  sleep 2

  locust -f transaction_locust.py --headless -u 1 -r 1 --run-time 12s
  sleep 2

  locust -f loan_locust.py --headless -u 1 -r 1 --run-time 7s
  sleep 5
}
#######################################################################################
## Cleanup
function cleanup_env {
  deactivate venv_locust
  rm -rf venv_locust
  rm -rf __pycache__
}
#######################################################################################
## End

setup_env

if [ -n "${1}" ] && [ "${1}" == "forever" ]; then
  echo "Running forever..."
  while true; do
    runner
  done
else
  echo "Running once."
  runner
fi

cleanup_env
echo "Done!"

