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
end
