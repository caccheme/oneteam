class CalendarsController < ApplicationController

def index
  @requests = Request.all
  @requests_by_date = @requests.group_by(&:start_date)
  @date = params[:date] ? Date.parse(params[:date]) : Date.today
end

end
