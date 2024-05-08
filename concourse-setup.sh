#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# A re-useable script to configure the environment for
# Concourse CI interactions.
# ---------------------------------------------------------------------------

# Set the target environment, passed in from the init.sh script in the same dir.
# Returns 0 if successful, 1 if failed.
function concourse_setup() {
  # Set the target environment, passed in from the init.sh script in the same dir.
  target=$1 # Should be "prod" or "dev"
  echo "Setting up Concourse CI Server for $target environment"

  # Default fly command or use provided FLY_CMD environment variable
  # TODO: Might need to check if this is valid for multiple versions.
  FLY_CMD="${FLY_CMD:-fly}"

  # Default Concourse CI Server URL
  CONCOURSE_URL="https://localhost:8080"

  # Check if fly executable is installed
  if ! [ -x "$(command -v "$FLY_CMD")" ]; then
    echo 'Error: fly is not installed.' >&2
    return 1
  else
    echo "Found fly executable at $(which $FLY_CMD), version: $($FLY_CMD -v)"
  fi

  #Configure fly login with Concourse CI Server
  CONCOURSE_LOGIN=$(cat ~/.flyrc | grep $target)

  if [[ -z $CONCOURSE_LOGIN ]]; then
    $FLY_CMD --target $target login --team-name main \
      --concourse-url $CONCOURSE_URL/
  else
    echo "Already logged in to Concourse CI Server: $CONCOURSE_URL"
    return 0
  fi
  
  #Login to Concourse CI Server
  $FLY_CMD -t $target status exit 2>&1 | grep -q 'in'
  status=$?
  if [[ $status == 1 ]]; then
    $FLY_CMD -t $target login
    return 0
  fi

  return 1
}
