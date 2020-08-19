user_1 = User.create(
  first_name: "Arun",
  last_name: "Sood",
  email: "arsood@gmail.com",
  password: "Password@1"
)

user_1.update(account_activation_token: nil)

user_2 = User.create(
  first_name: "Bob",
  last_name: "Jones",
  email: "bjones@gmail.com",
  password: "Password@1"
)

user_2.update(account_activation_token: nil)

puts "- Users Created -"
