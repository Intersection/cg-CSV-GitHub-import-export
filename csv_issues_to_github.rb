#!/usr/local/bin/ruby

# See the README for how to use this.

require 'rubygems'
require 'octokit'
require 'faraday'
require 'csv'
require 'optparse'
require 'ostruct'
require 'highline/import'

def password_prompt(message, mask='*')
  ask(message) { |q| q.echo = mask}
end

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

  opts.on("-o ORGANIZATION", "--organization ORGANIZATION", String, "Define you repo's local") do |o|
    if o == ""
      puts options
      exit
    end
    options.organization = o
  end

  opts.on("-r REPO", "--repository REPO", String, "Define you repo name") do |r|
    if r == ""
      puts options
      exit
    end

    options.repository = r
  end

  opts.on("-u USER", "--username USER", String, "Your username") do |u|
    options.username = u
  end

  opts.on("-k KEY", "--authkey KEY", String, "Your 40 char token") do |k|
    options.authkey = k
  end

  opts.on("-f FILE", "--file FILE", String, "CSV file") do |f|
    if f == ""
      puts options
      exit
    end
    options.file = f
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

opts_parser.parse!(ARGV)

org_repo = options.organization + "/" + options.repository

if options.authkey == ""
	options.password = password_prompt('#options.username password: ')
	client = Octokit::Client.new(:login => options.username, :password => options.password)
else
	client = Octokit::Client.new(:access_token => options.authkey)
end
user = client.user
user.login

csv_text = File.read(options.file)
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
	puts "Creating issue:  #{row['title']}"


	options = {
		:assignee => row['assignee_username'],
		:labels => []}

	$i=1
	while row['label#$i'] != nil do
		options.labels << row['label#$i']
	end

	client.create_issue(org_repo, row['title'], row['description'], options)

	puts "Imported issue:  #{row['title']}"
end

