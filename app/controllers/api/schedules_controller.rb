class Api::SchedulesController < Api::BaseController
  def create
    @schedule = Schedule.new(permitted_params)
    if @schedule.save
      render json: @schedule
    else
      render_validation_errors @schedule
    end
  end

  def show
    load_schedule
    render json: @schedule
  end

  def update
    load_schedule
    if @schedule.update_attributes(permitted_params)
      render json: @schedule
    else
      require 'pry'
      binding.pry
      render_validation_errors @schedule
    end
  end

  private

  def load_schedule
    @schedule ||= Schedule.find(params[:id])
  end

  def permitted_params
    params.require(:schedule).permit(
      :id,
      schedule_events_attributes: [
        '_destroy',
        :event_id,
        :id,
        :schedule_id
      ]
    )
  end
end
