class SkillsController < ApplicationController
  before_action :student_access
  def show
    @skill = Skill.find(params[:id])
  end
end
