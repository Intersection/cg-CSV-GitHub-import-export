Import-issues-to-GitHub-from-CSV
================================

###Caveat
**You should use two-factor authentication for git**. 2FA breaks this script (it's beyond my coding skills to overcome that, at the moment). You have been warned.

###Intro (WTF is this?)
Product Owners and Project Mangers _love_ spreadsheets! They want everything in spreadsheet form.

If you're using GitHub Issues (and we do) this means that one often needs to move things from GitHub into a spreadsheet ("I need a list of issues to show the client"), or from a spreadsheet into GitHub ("Here is the list of features we are committing to this sprint.") And, personally, I don't like doing things by hand if a computer can do them. And do them better.

Thus this repo.

There are two scripts here. One is for importing into GitHub Issues from a CSV file. The other is for getting issues out of GitHub and into a CSV file. 

NOTE: currently, if you have two-factor authentication on, you'll have to turn it off for this to work. Which is a pain.

###Documentation (The stuff you actually care about)

#####Getting Started

Make sure you have a GitHub account, that you know your username and password, and that you have access to the repository (repo) that you want to import to, or from which you wish to export.

You can use the "Clone in Desktop" or "Download Zip" functions on the GitHub page to download the files. If you want to do it using the command line, via ssh, use `git clone git@github.com:controlgroup/CSV-GitHub-import-export.git`

You will also need to install [octokit](https://github.com/octokit/octokit.rb).  



#####Importing issues into GitHub using csv_issues_to_github.rb

`./csv_issues_to_github.rb` to import issues *into* GitHub from a CSV

There are two ways to use this. You use it interactively (the default) or you can hard-code your information into the script. If you want to switch, you need to comment out the former and un-comment the latter. 

You will need to provide a CSV file to import.
You will also need to provide it your GitHub username, your GitHub password, the name of your organization, and the name of your repository. If you're working on your own account on not as part of an org, the org is just your GitHub username.

The CSV file MUST be in the following format:
`title,description,assignee_username,label1,label2,label3`

You can add more labels or remove labels to it if you wish. However...

_**Important note**_: all label fields need to be filled. So, if you know you have an issue with only one label, then you need to have only one label field. You do this by removing (or you can add) labels fields at the end of the script. The line for this is marked with a comment (currently it's line 66, but that could change.)
This is a known deficiency that will, with luck, eventually be fixed. 

Fields that have commas in them need to be in double quotes. (Some punctuation doesn't require this, other punctuation may.)

Either way you use this, you will have to provide your GH password. If you use it interactively, it will show your password on the command line. P-(


#####Exporting issues from GitHub to a CSV file using github_issues_to_csv.rb

`./github_issues_to_csv.rb` to export issues *from* GitHub into a CSV

This allows you to create a CSV file from issues in a repo. This, too, can be done interactively or not. And it will also show your password if you use it interactively.

You can also export only a specific milestone if you give it a milestone. If you don't provide a milestone, it will print all issues.

Note: It will put all labels in one column, without any delimiter. P-(


###Credits (The smart people who did the real work)
It should be noted that I'm not much of a programmer, and I got a tremendous amount of help from [Vik](https://github.com/datvikash) and [Evan](https://github.com/evan108108)

In addition `github_issues_to_csv` was adapted from the work of others, specifically: https://gist.github.com/henare/1106008 and https://gist.github.com/tkarpinski/2369729
