#!/usr/bin/env bash
while getopts a:n:u:d: flag
do
    # shellcheck disable=SC2220
    case "${flag}" in
        a) author=${OPTARG};;
        n) name=${OPTARG};;
        u) urlname=${OPTARG};;
        d) description=${OPTARG};;
    esac
done

echo "Author: $author";
echo "Project Name: $name";
echo "Project URL name: $urlname";
echo "Description: $description";

YOUR_TOKEN=$GH_TOKEN
echo "YOUR_TOKEN  : $YOUR_TOKEN";


YOUR_TOKEN=$GISTTOKEN
echo "YOUR_TOKEN: $YOUR_TOKEN";


echo "Preparing gist...  $(github.token)"

curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $YOUR_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/gists \
  -d '{"description":"Example of a gist","public":false,"files":{"README.md":{"content":"This gist contains metrics pictures"}}}'
  
echo "Configured new gist as a container for metrics"
#gh api \
#  --method PUT \
#  -H "Accept: application/vnd.github+json" \
#  -H "X-GitHub-Api-Version: 2022-11-28" \
#  /repos/$author/$repo_name/actions/secrets/METRICS_TOKEN \
#  -f encrypted_value='c2VjcmV0' \
#  -f key_id='012345678912345678'

#echo "Configured secret METRICS_TOKEN"
