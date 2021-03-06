class ProfilesController < ApplicationController
  include Wicked::Wizard
  steps :basic_info, :personal_info, :aditional_info, :profile_photos

  before_action :get_user
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  def finish_wizard_path
    wizard_path(:profile_photos)
  end

  def show
    @current_step = params[:id]

    unless @profile
      @profile = @user.build_profile
      @profile.save
    end

    @profile.profile_photos.new

    if @current_step == "personal_info"
      if !@profile.finish_basic_info?
        redirect_to wizard_path(:basic_info), alert: "Please fill all basic information"
        return
      end
    elsif @current_step == "aditional_info"
      if !@profile.finish_personal_info?
        redirect_to wizard_path(:personal_info), alert: "Please fill all personal information"
        return
      end
    elsif @current_step == "profile_photos"
      if !@profile.finish_additional_info?
        redirect_to wizard_path(:aditional_info), alert: "Please fill all additional information"
        return
      end
    end
    render_wizard
  end

  def update
    @profile.update(profile_params)
    render_wizard @profile
  end

  def set_profile_picture
    self.profile_picture_id = profile.photo.id

  end

  private
    def get_user
      @user = current_user
    end

    def set_profile
      @profile = @user.profile
    end

    def profile_params
      params.require(:profile).permit(:age, :name, :dob, :country, :state, :city,
                                      :religion, :language, :ethnicity, :occupation, :income, :household,
                                      :height, :weight, :bodytype, :smoker, :drinker, :children, :wantkids,
                                      :selfbio, :ideal, :tandc,
                                      :gender, :status, :education, :profile_heading,
                                      :expectations, courtship_preference_ids: [],
                                      profile_photos_attributes: [:id, :profile_id, :photo, :_destroy, :is_admin])
    end

end
