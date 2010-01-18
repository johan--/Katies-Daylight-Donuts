namespace :populator do
  task :locations => :environment do
    all = { :city => "Grand Island", :state => "NE", :country => "United States", :zipcode => "68803" }
    ["307 W. 12th", "2518 W. College", "2028 N. Howard"].each do |address|
      Location.create!(all.update(:customer => Customer.first, :address => address))
    end
  end
end
