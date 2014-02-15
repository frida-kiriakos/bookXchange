json.array!(@accounts) do |account|
  json.extract! account, :id, :name, :email, :education, :admin, :address, :password_digest
  json.url account_url(account, format: :json)
end
