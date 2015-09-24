docker run -it --rm --name issue-csv-github -v "$PWD":/usr/src/myapp -w /usr/src/myapp ruby:2.1 ruby csv_issues_to_github.rb
