# README

This is the laboratory for Conekta, add request tests for the endpoints (transactions and accounts)
, uses JWT for the authentication manage.

* Ruby and Rails version
This project was generated using Ruby 2.3.3 and Rails 5.1.4 --api only

* System dependencies

* Configuration

To run this project you need to have installed rails and ruby in your system, 


* Database creation

Uses by default SQlite for the development database, for create just run:
```
rake db:migrate
rake db:migrate RAILS_ENV=test
rake db:setup
```

* Database initialization

* How to run the test suite

To run the tests just run 
```
bundle exec rspec
```

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* To Run the system just run:
```
rails s
```

This run the project on the 3000 port

#API Documentation

##POST /users/signup
###Parameters
* email[:String] => Email of the user
* password[:String] => Password of the user
* password_confirmation[:String] => Password confirmation
* name[:String] => Name of the user
* lastname[:String] => Lastname of the user

Let you register a new User, it respond with the AuthToken,
this endpoint nis not authenticated.


##POST /auth/login
###Parameters
* email[:String] => Email of the user
* password[:String] => Password  of the user

This endpoint lets you authenticate the user, if the parameters are correct responds with the AuthenticationToken,
this endpoint nis not authenticated.


## Note
For the next endpoints you need to add the headers `'Content-Type': 'application/json' and `'Authorization': 'YOUR_AUTH_TOKEN'`


##POST /accounts
###Parameters
* user_id[:Integer] => The user relarted to the new account

Lets you create a new account with 0.0 initial balance related to the user_id,
for simplicity for the example use autogenerated id, this id is the account_id

##GET /accounts

Lets you get the current_user accounts

###POST /transactions
###Parameters
* user_id[:Integer] => User who start the transaction
* account_id[:Integer] => Account related to the transaction
* transaction_type[:String] => Type of the transaction oneOf["fund", "income", "expense"]
* amount[:String] => Amount foer the transaction
* destination_account[:Integer] => Target account for the transaction
* external_account[:String] => The External Account to use (In this example is just simulated with a sleep and a `external gateway call`)


###GET /users/:user_id/transactions
 
Get the :user_id transactions
 
###GET /users/:user_id/accounts
 
Get the :user_id accounts


##Example flow:

### Register a new User, copy the AuthenticationToken
```
POST /users
Content-Type: application/json


{
	"name": "test1",
	"lastname": "test1",
	"email": "test1@mail.com",
	"password": "test1",
	"password_confirmation": "test1"
}
```

### Now create a second User, to test transactions
```
POST /users
Content-Type: application/json


{
	"name": "test2",
	"lastname": "test2",
	"email": "test2@mail.com",
	"password": "test2",
	"password_confirmation": "test2"
}
```

### Lets create an account for each user
```
POST /accounts
Content-Type: application/json
Authorization: [YOUR_TOKEN]


{
	"user_id": 1
}
```

### For the second user
```
POST /accounts
Content-Type: application/json
Authorization: [YOUR_TOKEN]


{
	"user_id": 2
}
```

### Fund the account 1 with 5000
```
POST /transactions 
Content-Type: application/json
Authorization: [YOUR_TOKEN]


{
	"user_id": 1,
	"account_id": 1,
	"transaction_type": "fund",
	"amount": 5000,
	"destination_account": 1,
	"transaction_target_type": "external",
	"external_account": "34534543"
}
```

### Fund the account 2 with 5000
```
POST /transactions 
Content-Type: application/json
Authorization: [YOUR_TOKEN]


{
	"user_id": 2,
	"account_id": 2,
	"transaction_type": "fund",
	"amount": 5000,
	"destination_account": 2,
	"transaction_target_type": "external",
	"external_account": "5555555"
}
```

### Transfer 2000 from account1 to account2
```
```