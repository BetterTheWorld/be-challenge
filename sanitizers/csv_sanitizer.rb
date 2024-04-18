class CsvSanitizer < Hashie::Dash
  include Hashie::Extensions::IgnoreUndeclared
  include Hashie::Extensions::Dash::PropertyTranslation
  include Hashie::Extensions::DeepMerge

  property :external_id, from: :id, required: true, message: "must be set"
  property :intent_id, from: :account_external_ref
  property :value_in_cents, from: :value, required: true, message: "must be set"
  property :paid_at, required: true, message: "must be set"
  property :status, required: true, message: "must be set"
  property :currency
end
