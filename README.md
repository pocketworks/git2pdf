![](http://www.pocketworks.co.uk/images/git2pdf/logo.png)

by [Pocketworks](http://pocketworks.co.uk), a UK mobile apps and sales technology development company.

# Git2Pdf

**Print physical Kanban cards from your GitHub issues, and stick that sweet stuff on your office wall**

![](http://pocketworks.co.uk/images/git2pdf/git2pdf-on-wall.jpg)

## Install

    gem install git2pdf

## Use

### Single Repo

    # E.g. for this repo: https://github.com/uranusjr/macdown/issues
    $ git2pdf gen uranusjr/macdown -u tobinharris -p
    $ open issues.pdf

![](https://agilesurface-production.s3.amazonaws.com/images/3a0a74ed696fe6fddb3a9b7a9d84d03f)

### More repos

    $ git2pdf gen "uranusjr/macdown, pocketworks/git2rb" -u tobinharris -p
    $ open issues.pdf

### Personal Access Tokens and 2 Factor Auth

If you want this to work with 2 Factor Authentication, you will have to setup a personal access token here: https://github.com/settings/tokens. Then supply it as parameter '-t'. When this is enabled you don't need and are not prompted for username and password.

Some alternative examples for other use cases:

### Alternative 1

    $ git2pdf gen -u tobinharris -p xxx -r "my-project, come-cool-repo, another-repo" -o my-organisation
    $ open issues.pdf

### Alternative 2

    $ git2pdf gen -u tobinharris -p xxx -r "pocketworks/my-project, pocketworks/come-cool-repo, pocketworks/another-repo"

### Print from a specific label(s)

    $ git2pdf gen -u tobinharris -p xxx -r "pocketworks/my-project, pocketworks/come-cool-repo, pocketworks/another-repo" -p "label1, label2"

### Start printing from a specific issue number

    $ git2pdf gen -u tobinharris -p xxx -r "pocketworks/my-project, pocketworks/come-cool-repo, pocketworks/another-repo" -f 120

### Authenticate if using Github's 2 Factor Auth's 'Personal Token'

    $ git2pdf gen pocketworks/my-project -t 08923409sdlk230293kosl3209029

### Authenticate if using Github's 2 Factor Auth's 'Personal Token' and you want to supply the token in an interactive session (for security)

    $ git2pdf gen pocketworks/my-project -t token

TODO:

* Improve CLI syntax, it's a bit shite

## Features

* Generates a PDF of GitHub issues, so you can print them out and stick em' on your kanban board or scrum board or whatever.
* Include multiple repositories
* Designed to use minimal printer ink

# What's our workflow?

* We have a physical kanban board
* We get bored of duplicating your effort writing on index cards or post-it notes
* We manage all our features, business analysis, requirements and bugs in Github issues
* We tag our issues with a _class of service_ such as Bug, Feature, Task.
* We use waffle.io for different swim lanes on Github, and mirror these on our physical card wall
* Every Monday we print out our cards to `issues.pdf`
* We open it in Mac Finder, hit Cmd-Shift-2 to bring up the thumbs. Then select and delete any cards we've already printed, or that we don't want on the wall right now
* We chose print, A4, select 9 pages per sheet, and landscape
* We print it, grab some scissors, chop up the pages, and pin the cards on the wall
* Bosh!

## Contributing to github_issue_printer

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Tobin Harris. See LICENSE.txt for
further details.

