class User < ApplicationRecord
  has_secure_token
  after_create :send_welcome_email, if: :student?
  after_create :send_company_welcome_email, if: :company?
  after_create :send_admin_companies_email, if: :company?
  after_create :send_student_confirmation_mail, if: :student?

  enum role: { company: 0, college: 1, student: 2 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :student_skills, foreign_key: :student_id, class_name: "StudentSkill"
  has_many :skills, through: :student_skills
  belongs_to :college, class_name: "User", optional: true, dependent: :delete
  has_many :internships
  belongs_to :skill, optional: true


  validates :role, presence: true
  validates :address, presence: true, if: :student?
  # validates :city, presence: true
  #Company
  validates :company, presence: true, if: :company?
  validates :description, presence: true, if: :company?
  validates :skill, presence: true, if: :company?
  validates :phone, presence: true, if: :company?
  #Student
  validates :birthday, presence: true, if: :student?
  validates :college_id, presence: true, if: :student?
  validates :first_name, presence: true, if: :student?
  validates :last_name, presence: true, if: :student?

  has_many :company_hirings, foreign_key: :company_id, class_name: "Hiring"
  has_many :student_hirings, foreign_key: :student_id, class_name: "StudentHiring"

  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?
  after_validation :geocode, if: :city_changed?
  after_validation :geocode, if: :zipcode_changed?

  def self.college_list_name
    colleges.map{ |college| ["#{college.college_name} - #{college.city}", college.id]}
  end

  def self.colleges
    where(role: "college")
  end

  def full_address
    "#{num} #{address} #{zipcode} #{city}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def marker_color
    rand[]
  end

  def self.companies
    where(role: "company")
  end

  def self.with_lng_lat
    where
    .not(latitude: nil, longitude: nil)
  end

  def gmap_hash(users)
    Gmaps4rails.build_markers(users) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      if user.role == 'company'
        marker.infowindow(user.company)
      else
        marker.infowindow(user.college_name)
      end
      marker.picture({
        url: user.marker_picture(self),
        width: 70,
        height: 70,
        })
    end
  end

  def marker_picture(current_user)
    host = "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=" #A|007FFF|000000"
    if self.role == 'company'
      host + "|08D9D6|000000"
    elsif self.role == 'college'
      host + "|FF2E63|000000"
    else
      host + "|00FF00|000000"
    end
  end

  private

  def send_welcome_email
    StudentMailer.welcome(self).deliver_now
  end

  def send_company_welcome_email
    CompanyMailer.welcome(self).deliver_now
  end

  def send_admin_companies_email
    AdminMailer.new_company(self).deliver_now
  end

  def send_student_confirmation_mail
    CollegeMailer.student_confirmation(self).deliver_now
  end
end
