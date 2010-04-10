module ClockinTimesHelper
  def time(starts,ends)
    ends = Time.zone.now if ends.nil?
    distance_of_time_in_words(starts,ends, true)
  end
end
