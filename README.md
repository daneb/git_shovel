#### GIT SHOVEL 

* Currently searches for "passwords" in Repositories for Enterprise
* Connects to Github (including Enterprise) using the github API to gather information
* This works dynamically to follow Githubs Pagination using Link Header
* export TOKEN =     <---- Personal Token generated from your Enterprise Account

##### Usage
* ruby ./git_troll.rb
* Some basic input variables for example, if searching "code"
- keyword (eg. "password")
- pages (20)  // Git Limits returns 
- url  // Github Enterprise require api/version
- filename // name of file to save to

##### Pain
-  Github rate limits to 10 requests per minute
-  Github only allows partial results so you need to use pages
-  Github cannot effectively give you the true location of result, thus the link header must be used for determine "start" and "end" of pagination
