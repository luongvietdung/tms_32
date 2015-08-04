class UserSubjectsController < ApplicationController
  before_action :load_user_subject
  before_action :authenticate_user!

  def show
    @tasks = @subject.tasks
    @user_id = @user_subject.user_id
    @tasks.each do |task|
      @user_subject.user_tasks.find_or_initialize_by task_id: task.id,
        user_id: @user_id
    end
    @activities = @user_subject.activities.latest.paginate page: params[:page],
      per_page: 5

    respond_to do |format|
      format.html
      format.js { render "shared/activities" }
    end
  end

  def update
    if @user_subject.update user_subject_params
      flash[:success] = t "application.flash.user_subject_updated"
    else
      flash[:danger] = t "application.flash.user_subject_update_failed"
    end
    redirect_to user_subject_path @user_subject
  end

  private
  def load_user_subject
    @user_subject = UserSubject.find params[:id]
    @subject = @user_subject.subject
  end

  def user_subject_params
    params.require(:user_subject).permit user_tasks_attributes: [:id, :user_id,
      :task_id]
  end
end
