#!/usr/bin/env bash

set -e

script=$(basename $0)
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
rootDir="$( cd "$scriptDir/.." && pwd )"
region="eu-west-1"

usage="usage: $script [-a|--api-key -u|--url [-n|--name]
    -h| --help              this help
    -a| --api-key           API key
    -u| --url               GraphQL url
    -n| --name              name (optional)"

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
        -a|--api-key)
        apiKey="$2"
        shift
        ;;
        -u|--url)
        url="$2"
        shift
        ;;
        -n|--name)
        name="$2"
        shift
        ;;
        *)
        # Unknown option
        ;;
    esac
    shift # past argument or value
done


if [[ -z $apiKey ]]; then
    echo "You must specify an API key using -a or --api-key"
    exit 1
fi

if [[ -z $url ]]; then
    echo "You must specify an GraphQL url using -u or --url"
    exit 1
fi

if [[ -z $name ]]; then
    data='{ "query": "mutation { greet { greeting } }" }'
else
    data='{ "query": "mutation { greet(name: \"'$name'\") { greeting } }" }'
fi


curl \
  -X POST \
  -H "Content-Type: application/json" \
  -H "x-api-key: ${apiKey}" \
  --data "${data}" \
  ${url}