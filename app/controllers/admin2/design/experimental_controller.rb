module Admin2::Design
  class ExperimentalController < Admin2::AdminBaseController

    def index
      features = NewLayoutViewUtils.features(@current_community.id,
                                             @current_user.id,
                                             @current_community.private,
                                             CustomLandingPage::LandingPageStore.enabled?(@current_community.id))

      render :index, locals: { community: @current_community,
                               feature_rels: NewLayoutViewUtils::FEATURE_RELS,
                               features: features }
    end

    def update_experimental

    end

  end
end
