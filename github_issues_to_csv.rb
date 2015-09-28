#!/usr/bin/ruby
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
options.milestone = ""

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

  opts.on("-m MILESTONE", "--milestone MILESTONE", String, "Milestone Target") do |m|
    if m == ""
      puts options
      exit
    end
    options.milestone = m
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

TIMEZONE_OFFSET="-4"
org_repo = options.organization + "/" + options.repository

if options.authkey == ""
  options.password = password_prompt('#{options.username} password: ')
  client = Octokit::Client.new(:login => options.username, :password => options.password)
else
  client = Octokit::Client.new(:access_token => options.authkey)
end
user = client.user
user.login
 
csv = CSV.new(File.open(File.dirname(__FILE__) + "/" + options.file + ".csv", 'w', {:col_sep => ";"}))
 
puts "Initialising CSV file..."
#CSV Headers
header = [
  "Issue number",
  "Title",
  "Description",
  "Date created",
  "Date modified",
  "Labels",
  "Milestone",
  "Status",
  "Assignee",
  "Reporter"
]

csv << header
 
puts "Getting issues from Github..."
temp_issues = []
issues = []
page = 0
begin
	page = page +1
	temp_issues = client.list_issues("#{options.organization}/#{options.repository}", :state => "closed", :page => page)
	issues = issues + temp_issues;
end while not temp_issues.empty?
temp_issues = []
page = 0
begin
	page = page +1
	temp_issues = client.list_issues("#{options.organization}/#{options.repository}", :state => "open", :page => page)
	issues = issues + temp_issues;
end while not temp_issues.empty?
 
puts "Processing #{issues.size} issues..."
issues.each do |issue|

	labels = ""
	label = issue['labels'] || "None"
	if (label != "None")
		label.each do |item|
    		labels += item['name'] + " " 
    	end	
	end

	assignee = ""
	assignee = issue['assignee'] || "None"
	if (assignee != "None")
		assignee = assignee['login']
	end	

	milestone = issue['milestone'] || "None"
	if (milestone != "None")
		milestone = milestone['title']
	end
 
	if ((options.milestone == "") || (milestone == options.milestone))
    # Needs to match the header order above, date format are based on Jira default
    row = [
      issue['number'],
      issue['title'],
      issue['body'],
      DateTime.parse(issue['created_at'].to_s).new_offset(TIMEZONE_OFFSET).strftime("%d/%b/%y %l:%M %p"),
      DateTime.parse(issue['updated_at'].to_s).new_offset(TIMEZONE_OFFSET).strftime("%d/%b/%y %l:%M %p"),
      labels,
      milestone,
      issue['state'],
      assignee,
      issue['user']['login']
    ]
    csv << row
    end
end

puts "Done!"
