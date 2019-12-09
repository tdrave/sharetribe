module Admin2::General
  class EssentialsController < Admin2::AdminBaseController

    def index
      @community_customizations = find_or_initialize_customizations(@current_community.locales)
      all_locales = MarketplaceService.all_locales.map { |l|
        {locale_key: l[:locale_key], translated_name: t("admin.communities.available_languages.#{l[:locale_key]}")}
      }.sort_by { |l| l[:translated_name] }
      enabled_locale_keys = available_locales.map(&:second)
      render locals: {locale_selection_locals: { all_locales: all_locales, enabled_locale_keys: enabled_locale_keys, unofficial_locales: unofficial_locales }}
    end

    def has_preauthorize_process?(processes)
      processes.any? { |p| p.process == :preauthorize }
    end

    def unofficial_locales
      all_locales = MarketplaceService.all_locales.map{|l| l[:locale_key]}
      @current_community.locales.select { |locale| !all_locales.include?(locale) }
        .map { |unsupported_locale_key|
          unsupported_locale_name = Sharetribe::AVAILABLE_LOCALES.select { |l| l[:ident] == unsupported_locale_key }.map { |l| l[:name] }.first
          {key: unsupported_locale_key, name: unsupported_locale_name}
        }
    end
  end
end
