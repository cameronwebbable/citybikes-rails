# Citybike API

## Setup
- Clone the directory, then navigate to directory in terminal.
- Run the following:
  - `bundle install`
  - `yarn`
  - `rake db:create db:migrate RAILS_ENV=development`
  - `rake db:create db:migrate RAILS_ENV=test`
    - Note: because I'm using multiple databases via ActiveRecord, this is what consistently generated databases. There's probably some other setting I need to change/haven't found yet to instead be able to allow a simple `rake db:create db:migrate`. 
  - Done!

## Running the App
  - `rails s`
  - This also uses a Sidekiq queue. need to also run `bundle exec sidekiq -q network`
    - Note: why 'network' as the name? this queue has the one sole purpose of loading data from api & wanted to label it appropriately. 

## Testing
  - `bundle exec rspec`
  - Yes, I totally copied over the full citybikes response into a json file to use in mocking tests 😇😎. Rather use the full, real data than one I've manipulated.
