# SetupOrganization.call(name: "Shopify")
class SetupOrganization
  include Interactor::Organizer

  organize(CreateOrganization,
           GetReports,
           CreateReports,
           CreateTransactions)

  before do
    context.client = GalacticCommerceClient.instance
  end
end
