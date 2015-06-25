# This will get the first three projects that match kh
curl -u  <token>:x-oauth-basic 	\
	-G https://github.hetzner.co.za/api/v3/search/repositories?q=kh&sort=stars&order=desc 	\
     -H "Accept: application/vnd.github.preview" 	\
 	| jq '.items[0,1,2] | {description: (.repository.description), name: (.repository.full_name), html_url}'

