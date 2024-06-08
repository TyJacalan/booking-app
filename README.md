# SkillSetGo 
![logo-base-256x256-dd80392e52abe7eeb75b4483f29a5083769323fe4161b6ef86c828ad397c7b13](https://github.com/TyJacalan/booking-app/assets/143598524/f0dc5d3a-0c57-4e7a-91c4-b74cc6087736)


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
GMAIL_ADDRESS:
GMAIL_PASSWORD:
HOST_URL:
PAYMONGO_BASE_URL:
PAYMONGO_PUBLIC_KEY:
PAYMONGO_SECRET_KEY
```

3. Initialize the database
```
bin/rails db:create && 
bin/rails db:migrate &&
bin/rails db:migrate RAILS_ENV=test
```
4. Run the application
`bin/rails s`
