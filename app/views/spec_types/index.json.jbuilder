json.array!(@spec_types) do |spec_type|
  json.extract! spec_type, :id
  json.url spec_type_url(spec_type, format: :json)
end
