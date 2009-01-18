# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def user_unique_ical_url
    "#{ical_url}/#{current_user.token}" # if logged_in?
  end
  
end
