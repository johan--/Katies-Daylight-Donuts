#!/usr/bin/ruby


module ActionView
  class Base
    def current_host
      Rails.env =~ /production/ ? PRODUCTION_HOST : DEVELOPMENT_HOST
    end
  end
end

class String
  def next_day_of_week
    days = %w(mon tue wed thu fri sat sun)
    raise ArgumentError, "Mon - Sun are the only valid values" unless days.include?(self.downcase)
    days.each_with_index do |day_value, index|
      if day_value == self
        return days[index+1].nil? ? days[0] : days[index+1]
      end
    end
  end
end
