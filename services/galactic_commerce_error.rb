class GalacticCommerceError < StandardError
  attr_reader :error_data

  def initialize(error_data)
    @error_data = error_data
    super("Galactic Commerce Error: #{error_data[:message]} (Code: #{error_data[:code]})")
  end
end
