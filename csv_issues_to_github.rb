#!/usr/local/bin/ruby

# See the README for how to use this.

require 'rubygems'
require 'octokit'
require 'faraday'
require 'csv'

# BEGIN INTERACTIVE SECTION
# Comment out this section (from here down to where the end is marked) if you want to use this interactively

puts "Username:"
username = gets.chomp  
if username == ""
	abort("You need to supply a username. Thank you, come again.")
end

puts "Password:"
password = gets.chomp  
if password == ""
	abort("You need to supply a password. Thank you, come again.")
end

puts "Path for the CSV file you want to use?"
input_file = gets.chomp  
if input_file == ""
	abort("You need to supply a CSV file. Thank you, come again.")
end

puts "Organization?"
org = gets.chomp  
if org == ""
	abort("You need to supply an organization. Thank you, come again.")
end

puts "Repository?"
repo = gets.chomp  
if repo == ""
	abort("You need to supply a repository. Thank you, come again.")
end

# END INTERACTIVE SECTION


# BEGIN HARD-CODED SECTION
# Un-comment out this section (from here down to where the end is marked) if you want to use this without any interaction
# All of these need to be filled out in order for it to work
=begin
input_file = ""
username = ""
password = ""
org = "" 
repo = ""
=end  # END HARD-CODED SECTION

org_repo = org + "/" + repo

client = Octokit::Client.new(:login => username, :password => password)

csv_text = File.read(input_file)
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
	client.create_issue(org_repo, row['title'], row['description'], options = {
		:assignee => row['assignee_username'], 
		:labels => [row['label1'],row['label2'],row['label3']]})  #Add or remove label columns here.
	puts "Imported issue:  #{row['title']}"
end

