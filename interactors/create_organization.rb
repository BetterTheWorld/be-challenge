class CreateOrganization
  include Interactor

  def call
    account_token = context.client.register(context.params[:email], context.params[:email])&.token

    organization = Organization.new(name: context.params[:name],
                    email: context.params[:email],
                    encrypted_password: context.params[:password],
                    commerce_token: account_token
                    )

    if organization.save
      context.organization = organization
    end
  end

  private
end
