# Back End Challenge

## Solution

The `GalacticCommerceService` is designed to interact with the external API of Galactic Commerce Corp, facilitating connections between vendors and their clients. This service allows for user registration, login, retrieval, and processing of transaction reports in various formats (JSON, CSV, XML), and subsequently storing processed data in the Transaction database model.

### Service Methods

Below is the description of each method within the GalacticCommerceService.

#### `#register`

Registers a new user in the external system and stores the JWT received for authenticating future requests.

##### Parameters:

- email (String): The user's email address.
- password (String): The user's password.

##### Returns:

An object with the JWT on success or an error message on failure.

##### Example:

```ruby
service = GalacticCommerceService.new
service.register(email: "user@example.com", password: "P@$$word123")
```

#### `#login`

Logs in a registered user and updates the JWT.

##### Parameters:

- email (String): The user's email address.
- password (String): The user's password.

##### Returns:

The JWT on success or an error message on failure.

##### Example:

```ruby
service = GalacticCommerceService.new
service.login(email: "user@example.com", password: "SecurePassword")
```

#### `#fetch_reports`

Retrieves a list of reports available to the authenticated user. This method can process the reports immediately if a block is provided.

##### Returns:

A list of reports in JSON format.

##### Example without a block:

```ruby
service = GalacticCommerceService.new
service.login(email: "user@example.com", password: "SecurePassword")

service.fetch_reports
```

##### Example with a block:

```ruby
service = GalacticCommerceService.new
service.login(email: "user@example.com", password: "SecurePassword")

# same service

service.fetch_reports do |report|
  service.process_report(report_id: report["report_id"], currency: report["symbol"])
end

# diferent way

service.fetch_reports do |report|
  another_service_or_model.process(report)
end
```

#### `#process_report`

Processes a specific report based on its ID and currency, and saves relevant data to the database.

##### Parameters:

- report_id (String): The identifier of the report.
- currency (String): The currency in which the report values are expressed.

##### Returns:

A success message or an error if the processing fails.

##### Example:

```ruby
service = GalacticCommerceService.new
service.login(email: "user@example.com", password: "SecurePassword")

# fetch reports
reports = service.fetch_reports

# process
service.process_report(report_id: reports.last["repirt_id"], currency: reports.last["symbol"])
```

### Processing Strategies

Different report formats are handled by specific processing strategies:

- `JsonProcessor`
- `CsvProcessor`
- `XmlProcessor`

Each of these processors implements the process(data, currency) method, where data is the report information and currency is the corresponding currency.

### Usage

#### Bulk Processing

```ruby
# set the service

service = GalacticCommerceService.new

# if no accout

service.register(email: "armando.alejandre@example.com", password: "P@$$word123")

# or login if already an accout 

service.login(email: "armando.alejandre@example.com", password: "P@$$word123")

# process reports

service.fetch_reports do |report|
  service.process_report(report_id: report["report_id"], currency: report["symbol"])
end
```

#### Single Processing

```ruby
# set the service

service = GalacticCommerceService.new

# if no accout

service.register(email: "armando.alejandre@example.com", password: "P@$$word123")

# or login if already an accout 

service.login(email: "armando.alejandre@example.com", password: "P@$$word123")

# process reports

reports = service.fetch_reports do |report|
service.process_report(report_id: reports.last["report_id"], currency: reports.last["symbol"])
```

### Testing

#### Rspec

```bash
rspec 

# or

rspec spec/services
```

#### Manually

```bash
irb
```

then:

```ruby
require './app.rb'

service = GalacticCommerceService.new
service.register(email: "armando.alejandre@example.com", password: "P@$$word123")
service.fetch_reports do |report|
  service.process_report(report_id: report["report_id"], currency: report["symbol"])
end

Transaction.all
```

### Tools Used

#### Dependencies

```ruby
gem 'httparty'
```

#### Development Dependencies

```ruby
gem 'rspec'
gem 'rack-test'
gem 'vcr'
gem 'webmock'
gem 'factory_bot'
```

