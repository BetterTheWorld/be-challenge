## Back End Challenge

### Overview

  In this challenge you'll be connecting to an external API, receiving reports in various formats, and will have to translate them and store them in the database. You'll have to create a user and use the given token for http authentication. This exercise mimics how vendor portals behave in real-world applications. You may use any tools and add any gems as you see fit. You are allowed to use google, stack overflow, etc and to ask us questions. There are 3 different report formats: JSON(20), CSV(25) and XML(25). You're not expected to complete all of them. The goal of this exercise is not to complete it to perfection, but to see how you approach problems and design a solution. The challenge is encapsulated inside a sinatra app. You are not required to run it or build any views, it was just a convenient boilerplate.


### Objective
  The objective of this challenge is to process as many transaction reports as possible, and store each individual transaction in the database, extracting the attributes required by the Transaction ActiveRecord model found on `./models/transaction.rb`

### Instructions

1. Clone this repository
2. create a branch with your name
3. Run `bundle install`
4. Run `rake db:create` and `rake db:migrate RACK_ENV=test`
5. Run `rake spec` and ensure there are no failing tests.
6. Visit [https://be-challenge-uqjcnl577q-pd.a.run.app/](https://be-challenge-uqjcnl577q-pd.a.run.app/)
7. Follow the on screen instructions to create a user, receive a token and connect to the API.
8. Use any means you see fit to accomplish the objective outlined above.
9. You may use `irb` and `require './app.rb'` to have a working console with the application loaded.


### Notes
- Intent: An intent is a user initiated interaction with shopping, similar to viewing a product but not yet adding it to cart. The intent's is what is passed to the vendors to track that the shopping 'trip', and any resulting transactions, came form FlipGive.
