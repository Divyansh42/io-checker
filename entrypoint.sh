#!/usr/bin/env bash
set -e 
set -o pipefail 

# Define a timestamp function
timestamp() {
  date +"%T" # current time
}

npm ci

file_name="action-generated-ins-outs ${timestamp} .ts"
echo $file_name
npx action-io-generator --outFile=$file_name


git --no-pager diff --no-index --exit-code $INPUT_IO_FILE $file_name

function run(){
    echo "----- Contents of ${{ inputs.generated_filename }} -----"
    cat '${{ inputs.generated_filename }}'
    echo "----- End Contents ----"
    echo "---- Contents of ${{ inputs.committed_filename }} -----"
    cat '${{ inputs.committed_filename }}'
    echo "---- End Contents -----"
}

if [[ $? -eq 0 ]]; then
    echo "Inputs and Outputs are correctly configured"
else
    logFiles
fi

