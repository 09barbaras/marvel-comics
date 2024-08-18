# Marvel Comics

This project is an app designed to help users explore Marvel comics, offering features like user authentication, the ability to browse the most recent comics, search for comics by character name, and the option to mark comics as favorites for later access, making it a comprehensive tool for Marvel fans to discover and enjoy their favorite stories.

## Requirements
Ruby >= 3.2.2\
Rails >= 7.0.8

## Setup
### 1. Environment variables
Create a `.env` file with the appropriate variables. You can use the `.env.example` file as a reference:
````
cp .env.example .env
````
Fill in the required environment variables in the `.env` file.


### 2. Install Dependencies
```
bundle install
```

### 3. Set Up the Database
Create and migrate the database:
```
rails db:create
rails db:migrate
```

## Run the Application
To start the application locally on http://localhost:3001, run:
```
rails server
```

## Run tests
Run the entire test suite with:
```
bundle exec rspec
```

## Libraries and Approaches Used
#### Devise
Used devise for authentication and user management, since it's a widely-used and easy to setup authentication solution for Rails applications, providing a robust set of features out of the box.

#### Turbo and Stimulus
Provides fast and efficient page updates without requiring full page reloads. While Stimulus enhances the interactivity of the application by connecting JavaScript with HTML.

#### Tailwind CSS
Tailwind allows for rapid UI development with a consistent design.

#### Faraday
Used for making HTTP requests to external APIs. Faraday is a flexible and easy-to-use HTTP client library for Ruby, making it simple to interact with external APIs like the Marvel API.

#### Cache
To help mitigate any rate limiting issues, Rails cache was used to store the requests to the Marvel API and considerably reduce the number of requests necessary.

-------------------

Enjoy exploring Marvel comics!