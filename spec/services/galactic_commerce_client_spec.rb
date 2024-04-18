require 'rspec'
require 'httparty'
require 'vcr'
require 'spec_helper'

# rspec --format documentation
require './services/galactic_commerce_client'

RSpec.describe GalacticCommerceClient do
  let(:token) { 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ETUYUOkmfnWsWIvA8iBOkE2s1ZQ0V_zgnG_c4QRrhbg' }
  let(:report_id) { 1 }

  describe '#register' do
    it 'registers a user' do
      VCR.use_cassette('galactic_commerce_client/register') do
        client = described_class.instance
        response = client.register('dummy9@lms.com', 'Taco1234')

        expect(response.token).not_to be_nil
      end
    end

    context 'when the call fails' do
      it 'gets a 400 status code' do
        VCR.use_cassette('galactic_commerce_client/register_fail') do
          client = described_class.instance
          response = client.register('', '')

          expect(response.code).to eq(400)
        end
      end
    end
  end

  describe '#login' do
    it 'logs in a user' do
      VCR.use_cassette('galactic_commerce_client/login') do
        client = described_class.instance
        response = client.login('dummy9@lms.com', 'Taco1234')
        expect(response.token).not_to be_nil
      end
    end

    context 'when the call fails' do
      it 'gets a 401 status code' do
        VCR.use_cassette('galactic_commerce_client/login_fail') do
          client = described_class.instance
          response = client.login('bad_email', 'bad_password')

          expect(response.code).to eq(401)
        end
      end
    end
  end

  describe '#get_reports' do
    it 'get_reports' do
      VCR.use_cassette('galactic_commerce_client/reports') do
        client = described_class.instance

        token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ETUYUOkmfnWsWIvA8iBOkE2s1ZQ0V_zgnG_c4QRrhbg'
        response = client.get_reports(token)

        expect(response.map { |r| r['report_id'] }).to match_array([7426, 4738, 3745])
      end
    end

    context 'when the call fails' do
      let(:token) { '' }

      it 'gets a 403 status code' do
        VCR.use_cassette('galactic_commerce_client/reports_fail') do
          client = described_class.instance
          response = client.get_reports(token)

          expect(response.code).to eq(403)
        end
      end
    end
  end

  describe '#get_report' do
    context 'when report is a json format' do
      let(:report_id) { 7426 }

      it 'retrieved the json format' do
        VCR.use_cassette('galactic_commerce_client/single_report/as_json') do
          client = described_class.instance

          response = client.get_report_by_id(report_id, token)

          expect(response.map(&:class).uniq).to eq([Hash])
        end
      end
    end

    context 'when the report is a csv format' do
      let(:report_id) { 4738 }

      it 'retrieve the csv and convert it as hash' do
        VCR.use_cassette('galactic_commerce_client/single_report/as_csv') do
          client = described_class.instance

          response = client.get_report_by_id(report_id, token)

          expect(response.map(&:class).uniq).to eq([Hash])
        end
      end
    end

    context 'when the report is a xml format' do
      let(:report_id) { 3745 }

      it 'retrieve the xml' do
        VCR.use_cassette('galactic_commerce_client/single_report/as_xml') do
          client = described_class.instance

          response = client.get_report_by_id(report_id, token)

          expect(response.class).to eq(Hash)
        end
      end
    end

    context 'when the call fails' do
      let(:token) { '' }

      it 'gets a 403 status code' do
        VCR.use_cassette('galactic_commerce_client/single_report/fail') do
          client = described_class.instance

          response = client.get_report_by_id(report_id, token)

          expect(response.code).to eq(403)
        end
      end
    end
  end
end
