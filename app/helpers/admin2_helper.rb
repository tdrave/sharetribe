module Admin2Helper

  def expand_ul(group_name)
    'show' if expand_rules[group_name.to_sym]&.include?(controller_name)
  end

  def active_li(menu_name)
    'active' if menu_name == controller_name
  end

  def expand_rules
    {
      general: %w[essentials]
    }
  end
end
