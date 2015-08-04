class Supervisor::CoursesController < Supervisor::BaseController
  before_action :load_course, except: [:index, :new, :create]
  before_action :authorize_owner, only: :destroy

  def index
    @courses = current_user.courses.latest.paginate page: params[:page], per_page: 10
  end

  def show
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new course_params
    if @course.save
      @course.course_users.create user_id: current_user.id, is_owner: true
      flash[:success] = t "application.flash.course_created"
      redirect_to [:supervisor, @course]
    else
      render :new
    end
  end

  def edit
  end

  def update
    case params[:type]
    when "update_users"
      update_users
    when "close_course"
      close_course
    when "update_subjects"
      update_subjects
    else
      update_course
    end
  end

  def destroy
    if @course.destroy
      flash[:success] = t "application.flash.course_deleted"
    else
      flash[:danger] = t "application.flash.course_deleted_failed"
    end
    redirect_to supervisor_courses_path
  end

  private
  def update_course
    if @course.update course_params
      flash[:success] = t "application.flash.course_updated"
      redirect_to [:supervisor, @course]
    else
      render :edit
    end
  end

  def update_users
    if @course.update course_users_params
      flash[:success] = t "application.flash.users_updated",
        course: @course.name
    else
      flash[:danger] = t "application.flash.users_updated_failed",
        course: @course.name
      flash[:warning] = @course.errors.full_messages.join(", ")
    end
    redirect_to :back
  end

  def update_subjects
    if @course.update course_subject_params
      flash[:success] = t "application.flash.subject_update_success"
    else
      flash[:danger] = t "application.flash.subject_update_failed"
    end
    redirect_to :back
  end

  def close_course
    if @course.update_attributes closed: true, is_active: false
      flash[:success] = t "application.flash.closed_success",
        course: @course.name
    else
      flash[:danger] = t "application.flash.closed_failed",
        course: @course.name
    end
    redirect_to supervisor_courses_path
  end

  def load_course
    @course = Course.find params[:id]
  end

  def course_params
    params.require(:course).permit :name, :description, :start_date, :end_date,
      :is_active
  end

  def course_subject_params
    params.require(:course).permit subject_ids: []
  end

  def course_users_params
    params.require(:course).permit course_users_attributes: [:id, :user_id, :_destroy]
  end

  def authorize_owner
    unless @course.owned_by? current_user
      flash[:danger] = t "application.flash.permission_denied"
      redirect_to supervisor_root_path
    end
  end
end
