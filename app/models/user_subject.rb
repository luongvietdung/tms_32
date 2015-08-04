class UserSubject < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject
  belongs_to :course
  has_many :user_tasks
  has_many :activities, dependent: :nullify
  has_many :tasks, through: :user_tasks

  validates :user_id, uniqueness: {scope: [:subject_id, :course_id]}

  scope :filter_by_subject, ->subject_id{where subject_id: subject_id}
  scope :filter_by_user, ->user_id{where user_id: user_id}

  accepts_nested_attributes_for :user_tasks, allow_destroy: true,
    reject_if: proc{|a| a[:task_id] == "0"}

  def finished? user
    self.user_tasks.count == user.tasks.filter_by_subject(subject).count
  end

  private
  def create_subject_completed_log
    unless is_active
      create_activity_log subject_id, "subject_completed", course.id, id
    end
  end
end
