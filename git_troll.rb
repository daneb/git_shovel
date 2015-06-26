require 'rest-client'
require 'byebug'

class GitTroll
	attr_accessor :url, :token, :keyword
	attr_reader :start_page, :end_page

	def initialize(url, token, keyword, file_name)
		@url = url
		@token = token
		@keyword = keyword
		@file_name = file_name
	end

	def get_html_of_password_usage
		htmlbuilder = ""

		git_results = get_results_from_gitserver(1)
		total_found = git_results["total_count"].to_i

		puts "Heads up - total pages to process #{end_page}"

		(@start_page).upto(@end_page) { |page_no|

			git_results = get_results_from_gitserver(page_no)
			items_found = git_results["items"]
			
			puts "Page #{page_no}"

			items_found.each { |item|
				htmlbuilder << """
				<tr>
				<td>#{item["repository"]["name"]}</td>
				<td>#{item["name"]}</td>
				<td>#{item["path"]}</td>
				<td>#{CGI.escapeHTML(item["text_matches"][0]["fragment"])}</td>
				</tr>
				"""
			}
			sleep(5)
		}
		build_html(htmlbuilder)
	end

	private
	def git_code_search(page_no)
		 response = RestClient::Request.execute(:url => "https://#{@token}:x-oauth-basic@#{@url}/search/code?q=#{@keyword}+in:file&order=asc&page=#{page_no}&per_page=#{@per_page}}",
		 	:method => :get,
		 	:verify_ssl => false,
		 	:headers => { :accept =>  "application/vnd.github.v3.text-match+json" } )
	end

	def set_page_start_and_end(headers)
		match = headers[:link].match(/(\&page=\d*).*(\&page=\d*)/)
		@start_page = match[1].gsub("\&page=","").to_i
		@end_page = match[2].gsub("\&page=","").to_i
	end

	def get_results_from_gitserver(page_no)
		response = git_code_search(page_no)
		set_page_start_and_end(response.headers)
		JSON.parse(response)
	end

	def build_html(htmlbuilder)
		File.open(@file_name, 'w') { |file| file.write("""
		<html>
		<head>
		Git Passwords
		<!-- Latest compiled and minified CSS -->
		<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
		<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css'>
		</head>
		<body>
		<table class='table table-condensed table-striped'>
		<thead class='active'><td>Repo</td><td>File</td><td>Path</td><td>Code Snippet</td></thead>
		<tbody>
		#{htmlbuilder}
		</tbody>
		</table>
		</body>
		</html>
		""") } 
	end

end

url_enteprise = "https://github.codedtrue.com/api/v3"
url = "https://api.github.com/"
token = ENV['TOKEN']
keyword = "password"
file_name = "password.html"

troll = GitTroll.new(url, token, keyword, file_name)
troll.get_html_of_password_usage











