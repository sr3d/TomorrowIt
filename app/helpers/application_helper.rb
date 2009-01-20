# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def user_unique_ical_url
    "#{ical_url}/#{current_user.token}" # if logged_in?
  end
  
  def get_calendar_month_view_date_range( date = DateTime.now )
    month_start_date = ( date - ( date.day ) + 1 ).to_date
    month_end_date   = month_start_date.next_month    
    start_date = month_start_date.monday - 1
    end_date   = month_end_date.cwday == 6 ? 
                  month_end_date :
                  month_end_date + 6 - month_end_date.cwday
    return [ start_date, end_date ]
  end    
  
  
end
