#!/usr/local/bin/ruby

# See the README for how to use this.

require 'rubygems'
require 'octokit'
require 'faraday'
require 'csv'
require 'optparse'
require 'ostruct'

# BEGIN INTERACTIVE SECTION
# Comment out this section (from here down to where the end is marked) if you want to use this interactively

options = OpenStruct.new
options.organization = ""
options.repository = ""
options.username = ""
options.password = ""
options.authkey = ""
options.file = ""

opts_parser = OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  opts.separator ""
  opts.separator "Specific options:"

  opts.on("-o", "--organization", "Define you repo's local") do |o|
    options.organization << o
  end

  opts.on("-r", "--repository", "Define you repo name") do |r|
    options.repository << r
  end

  opts.on("-u", "--username", "Your username") do |u|
    options.username = u
  end

  opts.on("-p", "--password", "Your password") do |u|
    options.password = u
  end

  opts.on("-k", "--authkey", "Your 40 char token") do |k|
    options.authkey = k
  end

  opts.on("-f", "--file", "CSV file") do |f|
    options.file << f
  end

  opts.separator ""
  opts.separator "Common options:"

  # No argument, shows at tail.  This will print an options summary.
  # Try it and see!
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

end

opt_parser.parse!(ARGV)
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

org_repo = options.organization + "/" + options.repository

if options.authkey == ""
	client = Octokit::Client.new(:login => options.username, :password => options.password)
else
	client = Octokit::Client.new(:login => options.authkey)
end

csv_text = File.read(options.file)
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
	client.create_issue(org_repo, row['title'], row['description'], options = {
		:assignee => row['assignee_username'], 
		:labels => [row['label1'],row['label2'],row['label3']]})  #Add or remove label columns here.
	puts "Imported issue:  #{row['title']}"
end

