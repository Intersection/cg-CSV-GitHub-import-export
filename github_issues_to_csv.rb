#!/usr/bin/env ruby

require 'octokit'
require 'csv'
require 'date'


# BEGIN INTERACTIVE SECTION
# Comment out this section (from here down to where the end is marked) if you want to use this interactively

puts "Username:"
USERNAME = gets.chomp
if USERNAME == ""
	abort("You need to supply a username. Thank you, come again.")
end

puts "Password:"
PASSWORD = gets.chomp
if PASSWORD == ""
	abort("You need to supply a password. Thank you, come again.")
end

puts "Name of the file you want to create? (.csv will be appended automatically)"
OUTPUT_FILE = gets.chomp
if OUTPUT_FILE == ""
	abort("You need to supply a CSV file. Thank you, come again.")
end

puts "Organization?"
ORG = gets.chomp
if ORG == ""
	abort("You need to supply an organization. Thank you, come again.")
end

puts "Repository?"
REPO = gets.chomp
if REPO == ""
	abort("You need to supply a repository. Thank you, come again.")
end

puts "Do you want just one Milestone? If so, enter it now. Leave this blank to get the entire repo."
TARGET_MILESTONE = gets.chomp

# END INTERACTIVE SECTION


# BEGIN HARD-CODED SECTION
# Un-comment out this section (from here down to where the end is marked) if you want to use this without any interaction
# All of these need to be filled out in order for it to work
=begin
OUTPUT_FILE = ""
USERNAME = ""   # Put your GitHub username inside the quotes
PASSWORD = ""   # Put your GitHub password inside the quotes
ORG = ""        # Put your organization (or username if you have no org) name here
REPO = ""       # Put the repository name here
# Want to only get a single milestone? Put the milestone name in here:
TARGET_MILESTONE="" # keep this equal to "" if you want all milestones
=end  # END HARD-CODED SECTION


# Your local timezone offset to convert times
TIMEZONE_OFFSET="-4"

client = Octokit::Client.new(:login => USERNAME, :password => PASSWORD)

csv = CSV.new(File.open(File.dirname(__FILE__) + "/" + OUTPUT_FILE + ".csv", 'w'))

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
	temp_issues = client.list_issues("#{ORG}/#{REPO}", :state => "closed", :page => page)
	issues = issues + temp_issues;
end while not temp_issues.empty?
temp_issues = []
page = 0
begin
	page = page +1
	temp_issues = client.list_issues("#{ORG}/#{REPO}", :state => "open", :page => page)
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

	if ((TARGET_MILESTONE == "") || (milestone == TARGET_MILESTONE))
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
