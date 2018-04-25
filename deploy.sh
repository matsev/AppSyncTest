#!/usr/bin/env bash

set -e

script=$(basename $0)
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
rootDir="$( cd "$scriptDir/.." && pwd )"
region="eu-west-1"

usage="usage: $script [-s|--stack-name -r|--region
    -h| --help              this help
    -r| --region            AWS region (defaults to '$region')
    -s| --stack-name        web stack name"


#
# For Bash parsing explanation, please see https://stackoverflow.com/a/14203146
#
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -h|--help)
        echo "$usage"
        exit 0
        ;;
        -r|--region)
        region="$2"
        shift
        ;;
        -s|--stack-name)
        stackName="$2"
        shift
        ;;
        *)
        # Unknown option
        ;;
    esac
    shift # past argument or value
done

if [[ -z $stackName ]]; then
    echo "You must specify the stack name using -s or --stack-name"
    exit 1
fi

# Deploy the API
aws cloudformation deploy \
    --stack-name $stackName \
    --template-file cloudformation.yaml \
    --capabilities CAPABILITY_IAM \
    --region $region

# Get the url
url=(`aws cloudformation describe-stacks --stack-name $stackName \
    --query "Stacks[0].Outputs[?OutputKey == 'ApiUrl'].OutputValue" \
    --region $region \
    --output text`)

# Get the API key
apiKey=(`aws cloudformation describe-stacks --stack-name $stackName \
    --query "Stacks[0].Outputs[?OutputKey == 'ApiKey'].OutputValue" \
    --region $region \
    --output text`)

echo "GraphQL API URL: $url"
echo "GraphQL API key: $apiKey"
