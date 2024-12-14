# Mokkku

Japanese term Mokkku (モック) simply stands for mock. Mokkku is a simple library to provide fake data that is unique for your project. You can easily use LLM like GPT, Gemini, or Claude to fill the mock that based on your database schema. The library is inspired by the FFaker library.

### Why Mokkku is good alternative for (F)Faker

* It provides unique test data for your application that in many cases needs something more than values defined in (F)Faker
* It generates test data in any language
* It holds the context which make the test records as close to production values as possible so you won't end up with record where city is New York and country is France
* The generated data is more up to date than the data that FFaker holds

## Configuration

Add gem to the development and test groups in Gemfile:

```ruby
group :development, :test do
  gem 'mokkku'
end
```

By default, mocks directory is `./spec/mocks` but you can change it. Create initializer in `config/initializers/mokkku.rb`:

```ruby
Mokkku.configure do |config|
  config.mocks_path = './alternative/directory'
end
```

## Usage

Given you have `User` model with the `first_name`, `last_name`, and `location` attributes. Create `spec/mocks/user.yml` file with an array of attributes:

```yaml
- first_name: John
  last_name: Doe
  location: New York
- first_name: Tim
  last_name: Doe
  location: Paris
```

You can now get the test data by calling `Mokkku::User.first_name`, etc. Once you call the class method for the first time, the context is saved and you will get the data from the same record. Calling `Mokkku::User.first_name` will return `John` and then calling `Mokkku::User.location` will return `New York`. If you want to reset the context, call `Mokkku::User.reset_context!`

## Mock generation

Explore what parameters are available:

```bash
mokkku --help
```

Generation with GPT model:

```bash
mokkku --models=User,Company --api-key=value --llm-model=gpt
```

Generation with Claude model:

```bash
mokkku --models=User,Company --api-key=value --llm-model=claude
```

Generation with Gemini model:

```bash
mokkku --models=User,Company --api-key=value --llm-model=gemini
```

## Mock generation without LLM api keys

If you don't own paid account, you can simply generate the prompt, paste it into LLM chat window and the copy generated YAML:

```bash
mokkku --models=User,Company
```

The result for prompt generated for `User` model, paste into `./spec/mocks/user.yml` file, etc.

## Usage with FactoryBot

Remember to reset the context in the after build callback:

```ruby
FactoryBot.define do
  factory :user do
    first_name  { Mokkku::User.first_name }
    last_name   { Mokkku::User.last_name }
    location    { Mokkku::User.location }

    after(:build) { |_| Mokkku::User.reset_context! }
  end
end
```
