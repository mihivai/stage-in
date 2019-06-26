class HiringsController < ApplicationController
  before_action :student_access
  def index
    begin
      @hirings = Hiring.visibles
                       .not_accepteds
                       .not_denieds_for(a)
                       .group_by_score(a)
    rescue
      @hirings = { 3 => Hiring.college_filter(current_user) }
    end

    @student_hirings = current_user.student_hirings.order(:state).where.not(state: 0)
    @companies = @hirings.values.flatten.flatten.map { |hiring| hiring.company }.select { |company| !company.latitude.nil? }

    # Creating Markers
    company_hash = current_user.gmap_hash(@companies)
    college_hash = current_user.gmap_hash(current_user.college)
    @hash = company_hash.push(college_hash[0])
  end

  def show
    @hiring = Hiring.find(params[:id])
  end

end
