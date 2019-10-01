# Capybara accessible selectors

A set of Capybara selectors that allow you to find custom
controls by labels using aria compatible markup.

```ruby
page.find(:tab, "Personal details")

expect(page).to have_field "Name", validation_error: "Please supply a name"
```

See [documentation](lib/capybara_accessible_selectors.rb)

## Usage

Include in your Gemfile:

```ruby
group :test do
  gem "capybara_accessible_selectors", git: "https://github.com/citizensadvice/capybara_accessible_selectors"
end
```

## Local development

```bash
# install
bundle install

# lint
bundle exec rubocop

# test
# A local install of Chrome is required for the apperation driver
bundle exec rspec
```
