json.array!(@lovedones) do |lovedone|
  json.safety_notice_id lovedone.id
  json.followers_attributes lovedone.followers, :first_name, :last_name, :email
end