require 'spec_helper'

RSpec.describe GalacticCommerceService do
  let(:service) { GalacticCommerceService.new }

  describe "#register" do
    context "when the registration is successful" do
      it "registers a user and returns a token", :vcr do
        returned = service.register(email: "armando1@example.com", password: "P@$$word123")

        expect(service.response.code).to be(200)
        expect(service.jwt).to_not be_nil
        expect(service.jwt).to be(returned)
      end
    end

    context "when registration fails due to incorrect parameters" do
      it "fails when the email was taken", :vcr do
        returned = service.register(email: "armando1@example.com", password: "P@$$word123")

        expect(service.response.code).to be(400)
        expect(service.jwt).to be_nil
        expect(returned).to include(:error)
        expect(service.response.body.to_json).to match(/Email has already been taken/)
      end
    end
  end

  describe "#login" do
    context "when the login is successful" do
      it "logs in a user successfully and returns a token", :vcr do
        service.register(email: "armando2@example.com", password: "P@$$word123")
        returned = service.login(email: "armando2@example.com", password: "P@$$word123")

        expect(service.response.code).to be(200)
        expect(service.jwt).to_not be_nil
        expect(service.jwt).to be(returned)
      end
    end

    context "when login fails due to incorrect credentials" do
      it "fails to log in with incorrect password", :vcr do
        service.register(email: "armando3@example.com", password: "P@$$word123")
        returned = service.login(email: "armando3@example.com", password: "wrongPassword")

        expect(service.response.code).to be(401)
        expect(returned).to include(:error)
        expect(service.response.body.to_json).to match(/Bad credentials/)
      end
    end
  end

  describe "#fetch_reports" do
    context "when fetching reports is successful" do
      it "retrieves a list of reports", :vcr do
        service.register(email: "armando8@example.com", password: "P@$$word123")
        response = service.fetch_reports

        expect(service.response.code).to be(200)
        expect(response).to be_an(Array)
        expect(response.first).to include("report_id")
        expect(service.reports).to be_an(Array)
        expect(service.reports.first).to include("report_id")
      end

      it "processes each report with a given block", :vcr do
        service.register(email: "armando9@example.com", password: "P@$$word123")
        processed_reports = []
        response = service.fetch_reports do |report|
          processed_reports << report
        end

        expect(service.response.code).to be(200)
        expect(response).to be_an(Array)
        expect(response.first).to include("report_id")
        expect(service.reports).to be_an(Array)
        expect(service.reports.first).to include("report_id")
        expect(processed_reports).not_to be_empty
        expect(processed_reports.first).to include("report_id")
      end
    end

    context "when fetching reports fails due to invalid JWT" do
      it "handles unauthorized access", :vcr do
        service.jwt = "invalid_jwt_token"
        response = service.fetch_reports

        expect(service.response.code).to be(403)
        expect(response).to include(:error)
        expect(response[:error]).to match(/unexpected token/)
      end
    end
  end

  describe "#process_report" do
    context "when processing a report is successful" do
      it "processes the report correctly", :vcr do
        service.register(email: "armando22@example.com", password: "P@$$word123")
        response = service.fetch_reports
        service.process_report(report_id: response.last["report_id"], currency: response.last["symbol"])
        
        expect(service.response.code).to be(200)
        expect(Transaction.all).to_not be_empty
        expect(Transaction.first.intent_id).to_not be_nil
      end
    end

    context "when the report_id does not exist" do
      it "handles non-existing report_id correctly", :vcr do
        service.register(email: "armando23@example.com", password: "P@$$word123")
        response = service.process_report(report_id: "invalid_report_id", currency: "in_valid_currency")

        expect(service.response.code).to be(404)
        expect(response).to include(:error)
        expect(response[:error]).to match(/(Not Found)/)
      end
    end
  end
end
