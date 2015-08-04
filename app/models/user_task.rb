class UserTask < ActiveRecord::Base
  include Loggable

  belongs_to :user
  belongs_to :task
  belongs_to :user_subject

  validates :user_id, uniqueness: {scope: [:task_id, :user_subject_id]}

  scope :filter_by_user, ->user{where user_id: user.id}
  after_create :create_task_finished_log

  private
  def create_task_finished_log
    create_activity_log task_id, "task_finished", user_subject.course.id,
      user_subject.id
  end
end
