module Admin2Helper

  def expand_ul(group_name)
    'show' if expand_rules[group_name.to_sym]&.include?(controller_name)
  end

  def active_li(menu_name)
    'active' if menu_name == controller_name
  end

  def expand_rules
    {
      general: %w[essentials privacy]
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
      header: t("admin.communities.edit_details.community_name"),
      input_classes: 'form-control',
      info_text: I18n.t("admin.communities.edit_details.edit_community_name_description"),
      input_name: 'name',
      translations: translations
    }
  end

  def community_slogan_hash
    translations = find_community_customizations(:slogan)
    looks_link = link_to(t("admin.communities.edit_details.see_how_it_looks_like"), "/?big_cover_photo=true", id: "view_slogan_link", target: :_blank, rel: :noopener)
    info_text = I18n.t("admin.communities.edit_details.edit_community_slogan_description_hideable", :see_how_it_looks_like => looks_link)
    {
      header: t("admin.communities.edit_details.community_slogan"),
      input_classes: 'form-control',
      info_text: info_text,
      input_name: "slogan",
      translations: translations
    }
  end

  def community_description_hash
    translations = find_community_customizations(:description)
    looks_link = link_to(t("admin.communities.edit_details.see_how_it_looks_like"), "/?big_cover_photo=true", target: :_blank, rel: :noopener)
    info_text = I18n.t("admin.communities.edit_details.edit_community_description_description_hideable", :see_how_it_looks_like => looks_link)
    {
      header: t("admin.communities.edit_details.community_description"),
      input_classes: 'form-control',
      info_text: info_text,
      input_name: "description",
      translations: translations
    }
  end

  def find_community_customizations(customization_key)
    available_locales.inject({}) do |translations, (locale_name, locale_value)|
      translation = @community_customizations[locale_value][customization_key] || ""
      translations[locale_value] = { language: locale_name, translation: translation }
      translations
    end
  end
end
