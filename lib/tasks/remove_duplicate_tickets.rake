namespace :katies do
  desc "Cleans up duplicate tickets if they accidentally get created twice"
  task :remove_duplicates => :environment do
    Time.zone = "Central Time (US & Canada)"
    deliveries = Delivery.by_date
    deliveries.group_by(&:store).each do |store, deliveries|
      next if deliveries.size < 2
      puts "Pruning tickets for #{store.name}"
      puts "Select which delivery to delete or press n for next"
      deliveries.each_with_index do |d,index|
        puts "#{index+1}) #{d.id}"
      end
      puts "Removing delivery #{deliveries.last.id}"
      deliveries.last.destroy
      puts ""
    end
  end
end