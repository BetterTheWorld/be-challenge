class SetupCredentials
  include Interactor

  def call
    context.account_token = create_token
  rescue StandardError => e
    context.fail!(message: e.message, error_code: :invalid_argument)
  end

  private

  def create_token
    context.client.register(context.params[:email], context.params[:password])&.token
  end
end
