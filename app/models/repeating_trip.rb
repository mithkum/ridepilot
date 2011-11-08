class RepeatingTrip < ActiveRecord::Base
  include ScheduleAttributes

  belongs_to :provider
  belongs_to :customer
  belongs_to :pickup_address, :class_name=>"Address"
  belongs_to :dropoff_address, :class_name=>"Address"
  belongs_to :repeating_trip
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  validates_date :pickup_time
  validates_date :appointment_time

  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id

  #Create concrete trips from all repeating trips.  This method
  #is idempotent.
  def self.create_trips
    for repeating_trip in RepeatingTrip.all
      repeating_trip.instantiate
    end
  end

  def pickup_time=(datetime)
    write_attribute :pickup_time, format_datetime( datetime )
  end
  
  def appointment_time=(datetime)
    write_attribute :appointment_time, format_datetime( datetime )
  end

  def instantiate
    now = Time.now
    later = now.advance(:days=>21)
    attributes_to_remove = %w(id recurrence schedule_yaml created_at updated_at created_by_id updated_by_id)
    for date in schedule.occurrences_between(now, later)
      this_trip_pickup_time = Time.gm(date.year, date.month, date.day, pickup_time.hour, pickup_time.min, pickup_time.sec)

      if this_trip_pickup_time != pickup_time 
        attributes = self.attributes
        attributes_to_remove.each {|attr| attributes.delete(attr)}
        attributes["repeating_trip_id"] = id
        attributes["pickup_time"] = this_trip_pickup_time
        attributes["appointment_time"] = this_trip_pickup_time + (appointment_time - pickup_time)
        attributes["via_repeating_trip"] = true

        Trip.repeating_based_on(self).for_date(this_trip_pickup_time).each {|t| t.destroy } 
        Trip.new(attributes).save!
      end
    end
  end

  private
  
  def format_datetime(datetime)
    datetime.is_a?( String ) && %w{a p}.include?( datetime.last.downcase ) ? "#{datetime}m" : datetime
  end
end
