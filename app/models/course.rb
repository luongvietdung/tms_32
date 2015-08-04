class Course < ActiveRecord::Base
  include PrettyUrl
  has_many :course_users, dependent: :destroy, inverse_of: :course
  has_many :users, through: :course_users
  has_many :course_subjects
  has_many :subjects, through: :course_subjects
  has_many :user_subjects
  has_many :user_tasks, through: :user_subjects
  has_many :tasks, through: :subjects
  has_many :activities, dependent: :nullify

  validates :name, presence: true
  validates :description, presence: true, length: {minimum: 100}
  validate :start_date_cannot_be_greater_than_end_date

  accepts_nested_attributes_for :course_subjects, allow_destroy: true,
    reject_if: proc {|a| a[:subject_id].blank? || a[:subject_id] == "0"}

  scope :latest, -> {order created_at: :desc}
  scope :active, -> {where "is_active = ? OR closed = ?", true, true}

  accepts_nested_attributes_for :course_users, allow_destroy: true,
    reject_if: proc {|a| a[:user_id].blank? || a[:user_id] == "0"}

  def add_user user
    course_user = course_users.create user_id: user.id
    course_user.valid?
  end

  def remove_user user
    course_users.find_by(user_id: user.id).destroy
  end

  def start_date_cannot_be_greater_than_end_date
    if start_date > end_date
      errors.add(:start_date, t("courses.create.date_invalid"))
    end
  end

  def finished? user
    user_tasks = self.user_tasks.filter_by_user user
    user_tasks.count == self.tasks.count
  end

  def owned_by? user
    course_users.detect{|course_user| course_user.user_id == user.id &&
      course_user.is_owner == true}
  end

  def percent user
    user_tasks = self.user_tasks.filter_by_user user
    self.tasks.count > 0 ? user_tasks.count * 100 / self.tasks.count : 0
  end
end
