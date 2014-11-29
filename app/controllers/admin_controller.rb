class AdminController < ApplicationController
	require 'mongo'

	# to set the namespace so we don't have to use Mongo:: before every command
	include Mongo  
	before_action :signed_in_admin_user, :is_admin?
  def index
  	# list of accounts, books, with all options enabled
  	@accounts = Account.all
  	@books = Book.all.order('created_at DESC')
  end

  def make_admin
  	account = Account.find(params[:id])
  	account.update_column(:admin, true) 
  	if account.admin?
  		flash[:success] = "you have successfully assigned admin privileges to the user"  		
  	else
  		flash[:error] = "an error occurred"
  	end
  	redirect_to admin_path	
  end

  def revoke_admin
  	account = Account.find(params[:id])
  	account.update_column(:admin, false) 
  	if !account.admin?
  		flash[:success] = "you have successfully revoked admin privileges from the user"  		
  	else
  		flash[:error] = "an error occurred"
  	end
  	redirect_to admin_path	
  end

  # this method can be used by the admin to give credit to a user
  def credit
  	account = Account.find(params[:id])
  	account.update_column(:credit, account.credit + 1)
  	flash[:success] = "you have successfully incremented the user's credit"
  	redirect_to admin_path  	
  end

  def login
  	#login based on user's profile  	
  end

  def create_profile
    logger.info "======== generating a profile for the user"
    # also takes params[:id] as parameter

  	# this function will use the data collected to create a profile for the user's usual behavior
  	# profile creation will be enabled after the user has logged in the website for 10 times
  	# this is needed to train the system about the user behavior
  	
    account = Account.find(params[:id])
    user_token = account.remember_token

    logger.info "===== user_token #{user_token}"
    coll = MongoClient.new("localhost", 27017).db("bookxchange").collection("log")
  	# documents = coll.find("nginx.request_uri" => "/admin").to_a  # this returns an array of BSON objects
  	# can iterate through them using each
  	# data can be accessed using format
  	# d[0]['nginx']['user_ip']

  	# to get specific fields only:
  	# d = c.find({"nginx.request_uri" => "/admin"}, :fields => ["nginx.user_ip", "nginx.timestamp"]).to_a

    # coll.mapreduce(map,reduce,:out=>'analytics') # the output is saved in analytics collection
    # to access remember_token: document.nginx.http_cookie.remember_token

    # find the page the user accesses more frequently than others
    map_pages = map("request_uri")
    results = coll.map_reduce(map_pages, reduce, :out => "log_results", :query => {'nginx.http_cookie.remember_token' => user_token})
    pages = results.find().sort(:value => :desc).limit(3).to_a
    most_accessed_pages_array = []

    pages.each {|p| most_accessed_pages_array.append(p['_id'])}
    most_accessed_pages = most_accessed_pages_array.join(",")

    # find usual ip address

    # find usual access time

    # browser

    # operating system

    

    logger.info "=== most_accessed_page: #{most_accessed_pages}"

    flash[:success] = "profile created"
    redirect_to admin_path

  end

  private

  def map(parameter)
    map = "function () {" +
      "var key =  this.nginx.#{parameter};" +
      "emit(key,{count: 1});" +
    "};"    
  end

  def reduce
    reduce = "function(key, values) {" +
      "var total_count = 0;" +
      "for (var i = 0; i < values.length; i++) {" +   
        "total_count += values[i].count;" +
      "}" +
      "return total_count;" +
    "};"    
  end

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

  
end
