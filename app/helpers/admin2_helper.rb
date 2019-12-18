module Admin2Helper

  def expand_ul(group_name)
    'show' if expand_rules[group_name.to_sym]&.include?(controller_name)
  end

  def active_li(menu_name)
    'active' if menu_name == controller_name
  end

  def expand_rules
    {
      general: %w[essentials privacy static_content admin_notifications],
      design: %w[landing_page display experimental]
    }
  end

  def admin_title
    title = t('admin2.seo.title', title: content_for(:title), service_name: title_service_name)
    strip_tags(custom_meta_title(title.squish))
  end

  def admin_description
    title = t('admin2.seo.description', title: content_for(:title), service_name: title_service_name)
    strip_tags(custom_meta_description(title.squish))
  end

  def title_service_name
    @current_community.full_name(I18n.locale).to_s
  end

  def community_private_homepage_content
    translations = find_community_customizations(:private_community_homepage_content)
    {
      header: t('admin2.privacy.header'),
      input_classes: 'form-control',
      info_text: t('admin2.privacy.info_text'),
      input_name: 'private_community_homepage_content',
      translations: translations
    }
  end

  def community_essentials_hash
    translations = find_community_customizations(:name)
    {
      header: t('admin2.essentials.community_name'),
      input_classes: 'form-control',
      info_text: t('admin2.essentials.community_info_text'),
      input_name: 'name',
      translations: translations
    }
  end

  def community_slogan_hash
    translations = find_community_customizations(:slogan)
    {
      header: t('admin2.essentials.community_slogan'),
      input_classes: 'form-control',
      info_text: t('admin2.essentials.community_slogan_info_text'),
      input_name: 'slogan',
      translations: translations
    }
  end

  def community_description_hash
    translations = find_community_customizations(:description)
    {
      header: t('admin2.essentials.community_description'),
      input_classes: 'form-control',
      info_text: t('admin2.essentials.community_description_info_text'),
      input_name: 'description',
      translations: translations
    }
  end

  def bootstrap_class_for(flash_type)
    { success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info' }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}", role: "alert") do
        concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  def find_community_customizations(customization_key)
    available_locales.inject({}) do |translations, (locale_name, locale_value)|
      translation = @community_customizations[locale_value][customization_key] || ""
      translations[locale_value] = { language: locale_name, translation: translation }
      translations
    end
  end
end
