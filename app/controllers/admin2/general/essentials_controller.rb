module Admin2::General
  class EssentialsController < Admin2::AdminBaseController

    def index
      @community_customizations = find_or_initialize_customizations(@current_community.locales)
      all_locales = MarketplaceService.all_locales.map { |l|
        { locale_key: l[:locale_key],
          translated_name: t("admin.communities.available_languages.#{l[:locale_key]}") }
      }.sort_by { |l| l[:translated_name] }
      enabled_locale_keys = available_locales.map(&:second)
      render locals: { locale_selection_locals:
                         { all_locales: all_locales,
                           enabled_locale_keys: enabled_locale_keys,
                           unofficial_locales: unofficial_locales } }
    end

    def update_essential
      update_results = []
      analytic = AnalyticService::CommunityCustomizations.new(user: @current_user, community: @current_community)
      customizations = @current_community.locales.map do |locale|
        customizations = find_or_initialize_customizations_for_locale(locale)
        customizations.assign_attributes(community_custom_params(locale))
        analytic.process(customizations)
        update_results.push(customizations.update({}))
        customizations
      end
      update_results.push(@current_community.update(community_params))
      process_locales = unofficial_locales.blank?
      if process_locales
        enabled_locales = params[:enabled_locales]
        all_locales = MarketplaceService.all_locales.map { |l| l[:locale_key] }.to_set
        enabled_locales_valid = enabled_locales.present? && enabled_locales.map{ |locale| all_locales.include?(locale) }.all?
        if enabled_locales_valid
          MarketplaceService.set_locales(@current_community, enabled_locales)
        end
      end

      analytic.send_properties
      if update_results.all? && (!process_locales || enabled_locales_valid)
        # Onboarding wizard step recording
        state_changed = Admin::OnboardingWizard.new(@current_community.id)
                                                .update_from_event(:community_customizations_updated, customizations)
        if state_changed
          record_event(flash, 'km_record', { km_event: 'Onboarding slogan/description created' })
          flash[:show_onboarding_popup] = true
        end
        flash[:notice] = t("layouts.notifications.community_updated")
      else
        flash[:error] = t("layouts.notifications.community_update_failed")
      end
      redirect_to admin2_general_essentials_path
    end

    private

    def community_custom_params(locale)
      params.require(:community_customizations)
            .require(locale).permit(:name,
                                    :slogan,
                                    :description)
    end

    def community_params
      params.require(:community).permit(:description_color,
                                        :slogan_color,
                                        :show_slogan,
                                        :show_description)
    end

    def has_preauthorize_process?(processes)
      processes.any? { |p| p.process == :preauthorize }
    end

    def unofficial_locales
      all_locales = MarketplaceService.all_locales.map { |l| l[:locale_key] }
      @current_community.locales.select { |locale| !all_locales.include?(locale) }
                        .map { |unsupported_locale_key|
                          unsupported_locale_name = Sharetribe::AVAILABLE_LOCALES.select { |l| l[:ident] == unsupported_locale_key }.map { |l| l[:name] }.first
                          { key: unsupported_locale_key, name: unsupported_locale_name }
                        }
    end
  end
end
