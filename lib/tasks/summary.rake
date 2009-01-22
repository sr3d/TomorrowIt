namespace :summary do
	  desc "Updates video captions ratings"
	  task(:send_daily_summary => :environment) do
	    AdminNotifier.deliver_daily_summary
  end
end