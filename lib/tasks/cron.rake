task :cron => :environment do
 if Time.zone.now.hour == 21 # run at midnight
   Store.all_by_position.each do |store|
     store.create_todays_delivery!
   end
 end
end
