namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(email: "test@example.org",
                         password: "testing",
                         password_confirmation: "testing")
    admin.toggle!(:admin)
    99.times do |n|
      email = "example-#{n+1}@example.org"
      password  = "password"
      User.create!(email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end