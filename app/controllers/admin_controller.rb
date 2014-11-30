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

  
# this function will use the data collected to create a profile for the user's usual behavior
# profile creation will be enabled after the user has logged in the website for 10 times
# this is needed to train the system about the user behavior
# it takes params[:id] as parameter

  def create_profile
    logger.info "======== generating a profile for the user"  	
  	
    account = Account.find(params[:id])
    user_token = account.remember_token

    profile = account.profile ? account.profile : account.build_profile()

    # we are using a native driver for mongodb as opposed to a mapper
    coll = MongoClient.new("localhost", 27017).db("bookxchange").collection("log")
  	

    # find the top three pages the user accesses more frequently than others
    map_pages = map("request_uri")
    results = coll.map_reduce(map_pages, reduce, :out => "log_results", :query => {'nginx.http_cookie.remember_token' => user_token}, :limit => 100)
    pages = results.find().sort(:value => :desc).limit(3).to_a
    most_accessed_pages = []

    pages.each {|p| most_accessed_pages.append(p['_id'])}
    profile.pages = most_accessed_pages.join(",")

    # find usual ip address, we will take the most common two ip addresses 
    map_ip = map("user_ip")
    results = coll.map_reduce(map_ip, reduce, :out => "log_results", :query => {'nginx.http_cookie.remember_token' => user_token})
    ip_addresses = results.find().sort(:value => :desc).limit(2).to_a
    logger.info "===== ip_addresses #{ip_addresses}"

    common_addresses = []
    ip_addresses.each {|a| common_addresses.append(a['_id'])}
    profile.ip_address = common_addresses.join(',')

    logger.info "====== profile.ip_address #{profile.ip_address}"


    # find usual access time, we rely on the ip_address for this since remember_token does not exist when the user is logged out
    map_access_time = map("timestamp.hour")
    results = coll.map_reduce(map_access_time, reduce, :out => "log_results", :query => {'nginx.user_ip' => ip_addresses[0]['_id'], 'nginx.request_uri' => '/sessions', 'nginx.http_referer' => /(.*)signin/i})

    signin_time = results.find().sort(:value => :desc).limit(1).to_a
    logger.info "========= signin_time #{signin_time}"
    profile.access_time = signin_time[0]['_id'].to_i


    # browser and operating system
    map_user_agent = map("user_agent")
    results = coll.map_reduce(map_user_agent, reduce, :out => "log_results", :query => {'nginx.http_cookie.remember_token' => user_token}, :limit => 100)
    user_agent_array = results.find().sort(:value => :desc).limit(1).to_a
    user_agent = user_agent_array[0]['_id']

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

    profile.browser = browser
    profile.operating_system = os
    

    # Finally, save the profile for the user in the database
    if profile.save
      flash[:success] = "profile created successfully"
    else
      flash[:error] = "an error occurred, please check logs"      
    end
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
      "var reducedVal = {count: 0};" +
      "values.forEach( function(value) {" +
        "reducedVal.count += value.count;" +
      "});" +
      "return reducedVal;" +
    "};"    
  end
  
end
