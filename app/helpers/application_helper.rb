module ApplicationHelper

  def title
    base_line = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_line
    else
      "#{base_line} | #{@title}"
    end
  end



end
