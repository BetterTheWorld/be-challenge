# this interacor does not save the information
# in the organization and report tables
# only in the transaction table
class SimpleFlow
  include Interactor::Organizer

  organize(SetupCredentials,
           GetReports,
           CreateOnlyTransactions)

  before do
    context.client = GalacticCommerceClient.instance
  end
end
