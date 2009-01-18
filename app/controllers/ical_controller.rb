require 'icalendar'

class IcalController < ApplicationController
  def index
    @calendar = Icalendar::Calendar.new
    
    @tasks = Task.find_tasks_by_token( params[:token] )
    @tasks.each { |task| @calendar.add task.to_ical }
  end
end
