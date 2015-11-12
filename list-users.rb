#!/usr/bin/env ruby
#######################
#      Author : Brian Tilton
#        Date : 8/28/2015
#        Name : list-users.rb
# Description : Ruby script to list all users in PagerDuty. Uses API and
#                 pagination.
######################

require 'net/http'
require 'json'

##### Get API Token #####
APIFILE = File.readlines("#{File.dirname(__FILE__)}/api.token").each\
          {|f| f.chomp!}
APITOKEN = APIFILE[0]

##### Net Stuff #####
uri = URI.parse("https://odesk.pagerduty.com/api/v1/users?limit=100")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

headers = {
    "Authorization" => "Token token=#{APITOKEN}",
    "Content-type" => "application/json"
}

##### Main #####

reqOffset = 0

# Page through users until empty page
begin
    response = http.get("#{uri}&offset=#{reqOffset}", headers)
    datahash = JSON.parse(response.body)
    datahash["users"].each { |k| puts k["email"] }
    reqOffset += 100
end until datahash["users"].empty?

