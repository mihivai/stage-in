class Internship < ApplicationRecord
  has_many :hirings
  belongs_to :college

  def full_name
    "#{self.college.name} #{self.starts_at.strftime("du %m/%d/%Y")} #{self.ends_at.strftime("du %m/%d/%Y")}"
  end

  def self.display_internship
    all
    .map{|i| [i.full_name, i.id] }
  end
end
