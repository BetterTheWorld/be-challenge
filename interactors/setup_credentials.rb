class SetupCredentials
  include Interactor

  def call
    context.account_token = create_token
  end

  private

  def create_token
    context.client.register(context.params[:email], context.params[:password])&.token
  end
end
