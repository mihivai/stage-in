class SkillsController < ApplicationController
  before_action :check_access
  def show
    @skill = Skill.find(params[:id])
  end
  def check_access
    redirect_to root_path unless current_user.role == "student"
  end
end
