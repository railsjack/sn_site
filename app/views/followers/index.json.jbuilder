json.array!(@followers) do |follower|
  json.extract! follower, :id, :user_id, :lovedone_id, :request_status
  json.url follower_url(follower, format: :json)
end
