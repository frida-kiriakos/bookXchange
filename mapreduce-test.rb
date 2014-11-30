require 'rubygems'
require 'mongo'

include Mongo

client = MongoClient.new("localhost", 27017)
db = client.db("bookxchange")
coll = db.collection("log")

map = "function () {" +
	"var key =  this.nginx.user_agent;" +
	"emit(key,{count: 1});" +
"};"

map_pages = "function () {" +
	"var key =  this.nginx.request_uri;" +
	"emit(key,{count: 1});" +
"};"

map_signin_time = "function () {" +
	"var key =  this.nginx.timestamp.hour;" +
	"emit(key,{count: 1});" +
"};"

# reduce = "function(key, values) {" +
# 	"var total_count = 0;" +
# 	"for (var i = 0; i < values.length; i++) {" +		
# 		"total_count += values[i].count;" +
# 	"}"	+
# 	"return total_count;"	+
# "};"

reduce = "function(key, values) {" +
	"var reducedVal = {count: 0};" +
	"values.forEach( function(value) {"	+
		"reducedVal.count += value.count;" +
	"});" +
	"return reducedVal;" +
"};" 

# find distinct remember_token
user_tokens = coll.distinct( "nginx.http_cookie", {"nginx.http_cookie" => {"$ne" => "-"}})
# user_tokens = ["p7oHUNg-P8gxUiC2M94p5w"]

# then find the ip addresses associated with each token
user_tokens.each do  |token|
	puts token
	results = coll.map_reduce(map, reduce, :out => "log_results", :query => {'nginx.http_cookie' => token })

	ip_addresses = results.find().sort(:value => :desc).to_a
	puts ip_addresses

	# user_agent = results.find().to_a

	# puts user_agent
	
# 	results = coll.map_reduce(map_pages, reduce, :out => "log_results", :query => {'nginx.http_cookie.remember_token' => token})
# 	pages = results.find().sort(:value => :desc).limit(3).to_a

# 	most_accessed_page = pages[0]['_id']
# 	max_page = pages[0]['value']

# 	pages.each do |p|
# 		if p['value'].class == Float and p['value'] >= max_page
# 			max_page = p['value']
# 			most_accessed_page = p['_id']
# 		end
# 	end

# 	puts "accessed pages:"
# 	puts pages

# 	puts "most_accessed_page"
# 	puts most_accessed_page
# 	puts "addresses the user used: "
# 	# puts ip_addresses

	

# 	# find mostly used ip addresses
# 	most_used_ip = ip_addresses[0]['_id']
# 	max_ip = ip_addresses[0]['value']
	
# 	ip_addresses.each do |a|
# 		if a['value'].class == Float and a['value'] >= max_ip
# 			max_ip = a['value']
# 			most_used_ip = a['_id']
# 		end
# 	end
# 	puts "mostly used address"
# 	puts most_used_ip

# 	results = coll.map_reduce(map_signin_time, reduce, :out => "log_results", :query => {'nginx.user_ip' => most_used_ip, 'nginx.request_uri' => '/sessions'})
# 		# , 'nginx.http_referer' => /(.*)signin/i})
# 	signin_results = results.find().to_a

	# perform the same operation above to find the common signin times
end

# documents = coll.find("nginx.request_uri" => "/admin").to_a  # this returns an array of BSON objects
  	# can iterate through them using each
  	# data can be accessed using format
  	# d[0]['nginx']['user_ip']

  	# to get specific fields only:
  	# d = c.find({"nginx.request_uri" => "/admin"}, :fields => ["nginx.user_ip", "nginx.timestamp"]).to_a

    # coll.mapreduce(map,reduce,:out=>'analytics') # the output is saved in analytics collection
    # to access remember_token: document.nginx.http_cookie.remember_token

def find_max(records)
  max_record = records[0]['_id']
  max = records[0]['value']

  records.each do |p|
    if p['value'].class == Float and p['value'] >= max
      max = p['value']
      max_record = p['_id']
    end
  end

  return max_record
end

def check_user_agent
	agents = coll.distinct("nginx.user_agent")
	os = ""
	browser = ""

	agents.each do |user_agent|
		if user_agent.include?("Chrome")	  
		  os = user_agent.split("(")[1].split(")")[0]
		  browser = user_agent.split(" ")[-2]
		  
		elsif user_agent.include?("Firefox")
			os = user_agent.split("(")[1].split(")")[0]
		  browser = user_agent.split(" ")[-1]

		elsif user_agent.include?("MSIE")
			arr = user_agent.split(";")
			os = a[2].strip
		  browser = a[1].strip
		end

		puts "os: #{os}, browser: #{browser}"
	end
end
