class RegistrationsController < Devise::RegistrationsController
  def new
     # Building the resource with information that MAY BE available from omniauth!
     build_resource(:login => session[:omniauth_login])
     render :new
  end

  def create
    build_resource

    if session[:omniauth] && @user.errors[:login][0] =~ /has already been taken/
      user = User.find_by_login(@user.login)
      # Link Accounts - if via social connect
      return redirect_to link_accounts_url(user.id)
    end

    # normal processing
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  def build_resource(*args)
    super

    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def after_update_path_for(scope)
    session[:referrer] ? session[:referrer] : root_path
  end
end
