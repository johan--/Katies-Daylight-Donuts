# Black and White colors
stripes = ["EBEBEB","FFFFFF"]

pdf.text @employee.fullname, :size => 20, :align => :center

pdf.text "Schedule for #{@schedule.display_date}", :size => 10, :align => :center

data = @this_weeks_schedules.sort_by(&:display_date).map{ |schedule|
    [ {:text => schedule.display_date.to_s, :align => :center},
      {:text => schedule.starts.to_s, :align => :right},
      {:text => schedule.ends.to_s, :align => :right}, 
      {:text => schedule.total_hours.to_s, :align => :right} ]
}

pdf.table data, :border_style => :grid, 
          :position => :center,
          :row_colors => stripes,
          :headers => [
            {:text => "Date", :align => :center}, 
            {:text => "Starts", :align => :center}, 
            {:text => "Ends", :align => :center}, 
            {:text => "Total Hours", :align => :right}],
          :widths => {0 => 75, 1 => 200, 2 => 200, 3 => 75},
          :width => 600