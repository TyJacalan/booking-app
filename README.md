A starter template for a rails application that includes [Devise](https://github.com/heartcombo/devise) user authentication and views; unopiniated components, helpers, and stimulus controllers via [Shadcn](https://shadcn.rails-components.com/) and built with [Tailwind CSS](https://tailwindcss.com/).

## Main dependencies:

* Devise
* Omniauth
* Tailwind CSS
* Shadcn
* JSBunding
* Turbo Stimulus
* Rspec

## Features

- User authentication w/ tests
- Light/dark mode
- Custom error pages

## Usage/Examples
1. Install dependencies
`bundle install`

`yarn install`

2. Set the environment variables:
3. Do a global find and replace for `rails_auth_api_starter` with `your_project_name`
4. Create the users database
```
bin/rails db:create && 
bin/rails db:migrate &&
bin/rails db:migrate RAILS_ENV=test
```
5. Run the application
`bin/rails s`

## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

* `host`
* `google_oauth_client_id:`
* `google_oauth_client_secret:`
* ```
  google_smtp
  - email
  - password
