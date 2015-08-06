json.array!(@events) do |event|
  json.extract! event, :id, :title, :starts_at, :ends_at, :all_day, :description
  json.url event_url(event, format: :json)
end


