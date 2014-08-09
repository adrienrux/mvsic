class Api::SchedulesController < Api::BaseController
  before_filter :get_schedule, only: [:show, :update]
  before_filter :get_user, only: [:create]

  def create
    @schedule = Schedule.new(permitted_params.merge(user: @user))

    if @schedule.save
      UserMailer.schedule_email(@user, @schedule).deliver
      render json: @schedule
    else
      render_validation_errors @schedule
    end
  end

  def show
    render json: @schedule
  end

  def update
    if @schedule.update_attributes(permitted_params)
      render json: @schedule
    else
      render_validation_errors @schedule
    end
  end

  private
  def get_schedule
    @schedule ||= Schedule.find_by_hashed_id(params[:id])
  end

  def get_user
    @user = User.where(email: params[:email]).first_or_create
  end

  def permitted_params
    params.require(:schedule).permit(
      :id,
      :festival_id,
      schedule_events_attributes: [
        '_destroy',
        :event_id,
        :id,
        :schedule_id
      ]
    )
  end
end
