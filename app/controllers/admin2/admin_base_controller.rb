# This controller is parent for all controllers handling the admin area functions

class Admin2::AdminBaseController < ApplicationController
  layout 'layouts/admin'
  before_action :ensure_is_admin
  before_action :setup_seo_service

  #Allow admin to access admin panel before email confirmation
  skip_before_action :cannot_access_without_confirmation

  private

  def setup_seo_service
    @seo_service = SeoService.new(@current_community, params)
  end
end
