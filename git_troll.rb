require 'rest-client'
require 'byebug'

class GitTroll
	attr_accessor :url, :token, :keyword, :per_page

	def initialize(url, token, keyword, file_name, per_page)
		@url = url
		@token = token
		@keyword = keyword
		@file_name = file_name
		@per_page = per_page
	end

	def get_html_of_password_usage
		htmlbuilder = ""

		git_results = get_results_from_gitserver(1)
		total_found = git_results["total_count"].to_i
		pages = (total_found / per_page).to_i

		(1).upto(pages) { |page_no|

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
		}
		build_html(htmlbuilder)
	end

	private
	def git_code_search(page_no)
		 RestClient::Request.execute(:url => "https://#{@token}:x-oauth-basic@#{@url}/search/code?q=#{@keyword}+in:file&page=#{page_no}&per_page=#{@per_page}}",
		 	:method => :get,
		 	:verify_ssl => false,
		 	:headers => { :accept =>  "application/vnd.github.v3.text-match+json" } )
	end

	def get_results_from_gitserver(page_no)
		JSON.parse(git_code_search(page_no))
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
		<table class='table'>
		<thead><td>Repo</td><td>File</td><td>Path</td><td>Code Snippet</td></thead>
		<tbody>
		#{htmlbuilder}
		</tbody>
		</table>
		</body>
		</html>
		""") } 
	end

end

url = "github.hetzner.co.za/api/v3"
token = ENV['TOKEN']
keyword = "password"
per_page = 20
file_name = "password_colon.html"

troll = GitTroll.new(url, token, keyword, file_name, per_page)
troll.get_html_of_password_usage











