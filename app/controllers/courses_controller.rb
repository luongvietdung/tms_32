class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_course, :authorize_user, only: :show

  def index
    @courses = current_user.courses.active.latest.paginate page: params[:page],
      per_page: 10
  end

  def show
    @course_subjects = @course.user_subjects
    @supervisors = @course.users.supervisors
    @subjects = @course.subjects
    @members = @course.users.trainees
    @activities = @course.activities.latest.paginate page: params[:page],
      per_page: 5
    @user_subjects = @course.user_subjects

    respond_to do |format|
      format.html
      format.js {render "shared/activities"}
    end
  end

  private
  def load_course
    @course = Course.find params[:id]
  end

  def authorize_user
    unless @course.users.include? current_user
      redirect_to root_path
    end
  end
end
