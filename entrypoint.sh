#!/usr/bin/env bash
set -e 
set -o pipefail 

# Define a timestamp function
timestamp() {
  date +"%s"
}

npm ci

file_name="action-generated-ins-outs-$(timestamp).ts"
echo "Generating inputs and outputs enum in $file_name"

npx action-io-generator --outFile=$file_name

git --no-pager diff --no-index --exit-code $INPUT_IO_FILE $file_name || true

function logFiles(){
    echo "----- Contents of $file_name -----"
    cat $file_name
    echo "----- End Contents ----"
    echo "---- Contents of $INPUT_IO_FILE -----"
    cat $INPUT_IO_FILE
    echo "---- End Contents -----"
}   

if [[ $? -eq 0 ]]; then
    echo "✅ Inputs and Outputs are configured correctly."
else
    echo "❌ Inputs and Outputs are not configured correctly."
    logFiles
    exit 1
fi