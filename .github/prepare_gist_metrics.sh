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


echo "Preparing gist..."

#echo "$YOUR_TOKEN" | gh auth login --with-token
#gh api repos/${{ GITHUB.REPOSITORY }}/issues  --jq '.[].title'
#gh api \
#  -H "Accept: application/vnd.github+json" \
#  -H "X-GitHub-Api-Version: 2022-11-28" \
#  /gists  --jq='.[].description'

msg="test highlight1"
if [[ $(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $YOUR_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/gists | jq '.[].description') = *\"$msg\"* ]]; then
    echo "Found GIST with description '$msg'. Nothing to do."
else
    echo "GIST for holding of generated github statistic images not found. Trying to create.."
   
    json="'{\"description\":\"$msg\",\"public\":true,\"files\":{\"README.md\":{\"content\":\"hahaha\"}}}'"
    json=$(echo '{"description":"ddd","public":true,"files":{"README.md":{"content":"hahaha"}}}')
    echo $json
    echo "'$json'"
   #  -d '{"description":"edede","public":true,"files":{"README.md":{"content":"Tdee"}}}'
   #     '{"description":"tdddd","public":true,"files":{"README.md":{"content":"cddc"}}}'
   #  -d '{"description":"fffff","public":true,"files":{"README.md":{"content":"ffff"}}}'
    #curl -L --fail   \
    #  -H "Accept: application/vnd.github+json" \
    #  -H "Authorization: Bearer $YOUR_TOKEN" \
    #  -H "X-GitHub-Api-Version: 2022-11-28" \
    #  https://api.github.com/gist \
    #  -d '{"description":"ddd","public":true,"files":{"README.md":{"content":"hahaha"}}}'   
     echo "--------------------" 
     m=$(curl -L \
      -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $YOUR_TOKEN" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/gists \
      -d '{"description":"Example of a gist","public":false,"files":{"README.md":{"content":"Hello World"}}}')
      #m=$(curl -L --fail   \
      #-X POST \
      #-H "Accept: application/vnd.github+json" \
      #-H "Authorization: Bearer $YOUR_TOKEN" \
      #-H "X-GitHub-Api-Version: 2022-11-28" \
      #https://api.github.com/gist \
      #-d '{"description":"ddd","public":true,"files":{"README.md":{"content":"hahaha"}}}' 2>&1)
    if [ $? -ne 0 ] ; then
       echo "Could not create GIST. Create first token GIST_SECRET with appropriate permitions. Error executing CURL: $m"
    else   
       echo "Configured new GIST as a container for metrics"  
    fi     
fi
  
