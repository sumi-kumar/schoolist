json.array!(@schools) do |school|
  json.extract! school, :id, :name, :city, :zip
  json.url school_url(school, format: :json)
end
