module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
      "#{@title}"
  end
  
  def keywords
      "#{@keywords}"
  end
    
  def page_loaded
      "#{@page_loaded}"
  end
  
  
end
