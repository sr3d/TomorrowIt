# TomorrowIt
TomorrowIt is a simple to-do list application with a don't-break-the-chain calendar.  The application supports anonymous users as well so that you don't have to create an account to use it.

[<img src="http://cl.ly/9b08e988a180318214df/content" alt="Tomorrow It" />](http://tomorrowit.com)


# Development Setup

The app is running on Rails 2.1.1 and the framework is frozen so no additional gems are needed.

- clone the site:  $ git clone git@github.com:sr3d/TomorrowIt.git
- create the database:  $ rake db:create
- run migration: $ rake db:migrate 
- start the server:  $ ./script/server


# Live Site
The app is currently hosted on Heroku at http://tomorrowit.com/.