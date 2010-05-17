=begin
require 'fastercsv'

namespace :report do
  task :generate_csv => :environment do
    start_time  = ( Time.zone.now.at_beginning_of_month - 1.month )
    end_time    = ( start_time + 1.month )
    time_period = %Q{ #{start_time.strftime('%B, %Y')} - #{end_time.strftime('%B, %Y')} }
    csv_payload = FasterCSV.generate do |csv|
      csv << ["Invoice ID", "Store Name", "Created", "Delivery Date", "Addres", "Total"]
    Store.all_by_position.each do |store|
      deliveries = store.deliveries.printed.by_date(start_time, end_time)
      first_half_deliveries = deliveries.collect{|d| d if d.delivery_date < (start_time+2.weeks)}.compact
      second_half_deliveries = deliveries.collect{|d| d if d.delivery_date > (start_time+2.weeks)}.compact
      [["First Half of ",first_half_deliveries], ["Second Half of ",second_half_deliveries]].each do |set|
        set[1].each do |delivery|
          #next unless delivery.delivered?
          csv << [delivery.id, delivery.store.name, delivery.created_at.to_s(:db),delivery.delivery_date.to_s(:db), delivery.address, delivery.total]
        end
      end
    end
    end # end fastercsv
    filename = "/Users/me/Downloads/Reports/sales-report-#{rand(99)}"
    file = File.open((filename+".csv"),"w+")
    file.write(csv_payload)
    file.close
    UserNotifier.deliver_message(["klynnknoll@hotmail.com","timmy.matheson@gmail.com"], "", time_period, File.read((filename+".csv")))
  end
end
=end