# This will get all projects that begin with KH
curl -u  <token>:x-oauth-basic		\
	-G https://github.hetzner.co.za/api/v3/search/code          \
    --data-urlencode 'q=KH' \
    --data-urlencode 'sort=indexed'                   \
    --data-urlencode 'order=desc'                     \
    -H 'Accept: application/vnd.github.preview'       \
    | jq '.items[0,1,2] | {description: (.repository.description), name: (.repository.full_name), html_url}'
