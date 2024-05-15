# Booking App

An appointment scheduling app tailored specifically for freelancers and clients in the Philippines.

## Main dependencies:

* Devise
* Omniauth
* Tailwind CSS
* Shadcn
* JSBunding
* Turbo Stimulus
* Rspec

## Features

- Profile management
- Booking system
- Location-based search
- Review and rating system
- Payment integration

## Usage/Examples
1. Install dependencies
```bundle install && yarn install```

2. Set the environment variables:
```
```
3. Initialize the database
```
bin/rails db:create && 
bin/rails db:migrate &&
bin/rails db:migrate RAILS_ENV=test
```
4. Run the application
`bin/rails s`
