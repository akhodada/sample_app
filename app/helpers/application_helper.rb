module ApplicationHelper

  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end
  def title
    base_line = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_line
    else
      "#{base_line} | #{@title}"
    end
  end



end
