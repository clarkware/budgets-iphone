Budgets
=======

An example iPhone application that talks to a RESTful Rails application to manage budgets and their related expenses.

Why?
----

This application is intended as a demonstration of how to use
[ObjectiveResource](http://iphoneonrails.com/) to manage two (nested)
resources living in a Rails application. I first created this application as
one of the examples used in my [360|iDev talk](http://www.360idev.com) in
October 2009.

Oh, and because programming is fun.  :-)

Features
--------

Again, this app is intended for demonstration purposes only, but it sports a few features you may want to consider in your application:

* Supports all CRUD operations of two resources (Budget and Expense)
* Nested resources
* Asynchronous network requests
* Authentication
* Error handling

For a simpler, stripped down example of how to get started with ObjectiveResource using a single resource, check out the [Expenses app](http://github.com/clarkware/expenses-iphone/).

Quickstart
----------

1. Fire up the Rails application:

        $ cd server/budgets
        $ rake db:migrate
        $ ruby script/server
  
2. Point your trusty browser at the [running Rails app](http://localhost:3000/budgets), and create an account and a budget.

3. Open the iPhone project and run it!

        $ cd client/Budgets
        $ open Budgets.xcodeproj

Screenshots
-----------

This app won't win any design awards, but that's not the point...

* [Authentication](http://github.com/clarkware/budgets-iphone/raw/master/screenshots/authentication.png)
* [Editing Nested Resources](http://github.com/clarkware/budgets-iphone/raw/master/screenshots/nested-resources.png)
        
Additional Resources
--------------------

Of course there are alternatives to ObjectiveResource, though they aren't designed specifically to work with Rails:

* [httpriot](http://github.com/caged/httpriot)
* [ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/)
        
Author
------

Mike Clark 
mike@clarkware.com
