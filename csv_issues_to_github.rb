#!/usr/bin/env ruby

# See the README for how to use this.

require 'rubygems'
require 'octokit'
require 'faraday'
require 'csv'
require 'highline/import'
require 'pathname'

# BEGIN INTERACTIVE SECTION
# Comment out this section (from here down to where the end is marked) if you want to use this interactively

puts "Username:"
username = gets.chomp
if username == ""
	abort("You need to supply a username. Thank you, come again.")
end

password = ask("Password:  ") { |q| q.echo = false }.chomp
if password == ""
	abort("You need to supply a password. Thank you, come again.")
end

puts "Path for the CSV file you want to use?"
input_file = gets.chomp
if input_file == ""
	abort("You need to supply a CSV file. Thank you, come again.")
end
full_path = Pathname.new(input_file).expand_path
abort("Can't find file at that location: #{full_path}") unless full_path.exist?

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
username = ""
password = ""
full_path = Pathname.new('/path/to/your.csv').expand_path
org = ""
repo = ""
=end  # END HARD-CODED SECTION

org_repo = org + "/" + repo

client = Octokit::Client.new(:login => username, :password => password)

csv = CSV.parse(csv_text, :headers => true)
csv_text = File.read(full_path)

csv.each do |row|
	client.create_issue(org_repo, row['title'], row['description'], options = {
		:assignee => row['assignee_username'],
		:labels => [row['label1'],row['label2'],row['label3']]})  #Add or remove label columns here.
	puts "Imported issue:  #{row['title']}"
end

