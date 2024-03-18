#!/usr/bin/env bash
while getopts a:n:u:d:g: flag
do
    # shellcheck disable=SC2220
    case "${flag}" in
        a) author=${OPTARG};;
        n) name=${OPTARG};;
        u) urlname=${OPTARG};;
        d) description=${OPTARG};;
        g) gist_magic_desc=${OPTARG};;
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

msg="test highlight1"
if [[ $(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $YOUR_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/gists | jq '.[].description') = *\"$msg\"* ]]; then
    echo "Found GIST with description '$msg'. Nothing to do."
else
    echo "GIST for holding of generated github statistic images not found. Trying to create.."
    m=$(curl -L --fail  \
      -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $YOUR_TOKEN" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/gists \
      -d '{"description":"'"$gist_magic_desc"'","public":false,"files":{"README.md":{"content":"'"$gist_magic_desc"'"}}}')

    if [ $? -ne 0 ] ; then
       echo "Could not create GIST. Create first token GIST_SECRET with appropriate permitions. Error executing CURL: $m"
       exit 4
    else   
       echo "Configured new GIST as a container for metrics"  
       echo "Output from CURL: $m"
       committer_gist_id=$(echo "$m" | jq --raw-output '.id')
       echo $committer_gist_id
       original_gist_id="committer_gist_id"
       for filename in $(git ls-files) 
        do
          if [[  "$filename" = ".github/prepare_gist_metrics.sh" ]]; then
            echo "Omitting this file self for that substitution"
          else
            sed -i "s/$original_gist_id/$committer_gist_id/g" "$filename"
            echo "Substituted in $filename"
          fi 
        done
    fi     
fi
  
