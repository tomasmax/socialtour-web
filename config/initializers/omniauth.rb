
Rails.application.config.middleware.use OmniAuth::Builder do

  provider :twitter, 'PLIQQa5dmKj7xWZFhUNMA', 'JShprseVWjBCBUhzGhl5C3HtQSIgxBDieVm5MJtwQ'
  provider :facebook, '249864511822599', 'a3e46c549e0b4d6a1ad2c8b5f7330fb3'
  provider :google_oauth2, "766938582563.apps.googleusercontent.com", "hK3UHESG3OtQFRW9Cy96xo9O"
  provider :foursquare, "IN2OMEKAQP0JAZUB4G2YE5GS11AA3F2TRCCWQ5PVXCEG55PG", "CHUBYYCIGCD5H54IB43UQOE4C3PU4FKAPI4CGW0VNQD21SYE"
end