json.array!(@specs) do |spec|
  json.extract! spec, :id
  json.url spec_url(spec, format: :json)
end
