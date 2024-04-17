## Back End Challenge

### Usage 

```ruby
# set the service

service = GalacticCommerceService.new

# if no accout

service.register(email: "armando.alejandre@example.com", password: "P@$$word123")

# or login if already an accout 

service.login(email: "armando.alejandre@example.com", password: "P@$$word123")

# process reports

service.fetch_reports do |report|
  service.fetch_report(report_id: report["report_id"], currency: report["symbol"])
end
```
