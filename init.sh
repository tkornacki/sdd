#!/usr/bin/env bash

# Error codes
ERR_ARGS_MISSING=1
ERR_APP_UNKNOWN=2
ERR_PIPELINE_FILE_MISSING=3

pipeline_env="dev"
pipeline_name=""
pipeline_file=""
job_name=""

show_help() {
  echo "Usage: $0 -f <pipeline_file> -n <pipeline_name> "
  # echo "  -e <required> pipeline_env: dev"
  echo "  -f <required> pipeline_file: location of the pipeline file"
  echo "  -n <required> pipeline_name: name of the pipeline to deploy"
  echo "  -j <optional> job_name: name of the job to run"
}

while getopts "h:f:j:n:" opt; do
  case ${opt} in
    f )
      pipeline_file=$OPTARG
      ;;
    n )
      pipeline_name=$OPTARG
      ;;
    j )
      job_name=$OPTARG
      ;;
    h )
      show_help
      exit 0
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      show_help
      exit 1
      ;;
  esac
done

# These flags are required
if [ -z "$pipeline_env" ] || [ -z "$pipeline_name" ] || [ -z "$pipeline_file" ]; then
  echo "Error: Missing required arguments"
  show_help
  exit $ERR_ARGS_MISSING
fi

# Make sure the pipeline file exists
if [ ! -f "$pipeline_file" ]; then
  echo "Error: Pipeline file not found."
  exit $ERR_PIPELINE_FILE_MISSING
fi

# Source the concourse-setup-dev.sh script
source ./concourse-setup.sh
concourse_setup "$pipeline_env"
setup_success=$?

if [[ $setup_success -ne 0 ]]; then
  echo "Failed to setup Concourse CI Server"
  exit 1
fi

# Set pipeline file template
if [[ ! -f $pipeline_file ]]; then
  echo "Pipeline file $pipeline_file not found"
  exit $ERR_PIPELINE_FILE_MISSING
fi

# Validate the pipeline file, capture response
$FLY_CMD -t $pipeline_env validate-pipeline --config $pipeline_file
validate_response=$?

# If validate_response is not "looks good", exit with error
if [[ $validate_response -ne 0 ]]; then
  # Command will output results
  exit 1
fi

# Get a list of all current pipelines
$FLY_CMD -t $pipeline_env pipelines | grep $pipeline_name
pipeline_exists=$?

# If the pipeline does not exist, ask if we want to create the new pipeline
if [[ $pipeline_exists -ne 0 ]]; then
  echo "Pipeline $pipeline_name does not exist in $pipeline_env. Would you like to create it? (y/n)"
  read create_pipeline
  if [[ $create_pipeline != "y" ]]; then
    echo "Exiting without creating pipeline"
    exit 0
  fi
fi

# Set pipeline
$FLY_CMD -t $pipeline_env set-pipeline --pipeline $pipeline_name --config $pipeline_file --non-interactive

# Unpause pipeline, will begin running based on pipeline configuration
$FLY_CMD -t $pipeline_env unpause-pipeline --pipeline $pipeline_name

# Ff the job_name is not empty, run the job
if [[ $job_name != "" ]]; then
  # Check if the job exists
  $FLY_CMD -t $pipeline_env jobs -p $pipeline_name | grep $job_name
  job_exists=$?

  if [[ $job_exists -ne 0 ]]; then
    echo "Job $job_name does not exist in pipeline $pipeline_name"
    exit 1
  fi

  echo "Running job $pipeline_name/$job_name"
  $FLY_CMD -t $pipeline_env trigger-job -j $pipeline_name/$job_name -w
fi