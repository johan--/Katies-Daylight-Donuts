module ActionView
  module Helpers
    class FormBuilder
      include ActionView::Helpers
      
      def twelve_hour_select(object_name, method, options = {})
        current_hour = Time.respond_to?(:zone) ? Time.zone.now.hour : Time.now.hour
        selected = options.assert_valid_key?(:selected) ? Date.parse(options[:selected].to_s) : current_hour
        content = ""
        content << hidden_field_tag("#{object_name}[#{method}(1i)]", nil, 
          {:id => "#{object_name}_#{method}_1i", :value => "#{selected.year}" })
        content << hidden_field_tag("#{object_name}[#{method}(2i)]", nil, 
          {:id => "#{object_name}_#{method}_2i", :value => "#{selected.month}" })
        content << hidden_field_tag("#{object_name}[#{method}(3i)]", nil, 
          {:id => "#{object_name}_#{method}_3i", :value => "#{selected.day}" })
        
        4.upto(5) do |n|
          if n == 4
            hour_html_options = ""
            0.upto(23) do |hour|
              amorpm = (hour > 12) ? "PM" : "AM"
              display_hour = (hour > 12) ? (hour-12) : hour
              hour_html_options <<  content_tag(:option, "#{display_hour} #{amorpm}", :value => hour, :selected => (selected == hour))
            end
            content << content_tag(:select, hour_html_options, :name => "#{object_name}[#{method}(#{n}i)]", :id => "#{object_name}_#{method}_#{n}i")
          end
                    
          if n == 5
            minutes_html_options = ""
            [0,15,30,45].each do |minutes|
              minutes_display = (minutes == 0) ? 00 : minutes
              minutes_html_options << content_tag(:option, minutes_display, :value => minutes)
            end
            content << content_tag(:select, minutes_html_options, :name => "#{object_name}[#{method}(#{n}i)]", :id => "#{object_name}_#{method}_#{n}i")
          end
        end
        content
      end
    end
  end
end

class Hash
  def assert_valid_key?(key)
    self.symbolize_keys.has_key?(key.to_sym) && !self[key].blank?
  end
end