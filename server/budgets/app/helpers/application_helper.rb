module ApplicationHelper
  def banner(name, *actions)
    @page_title = "| #{h(name)}"
    actions = content_tag(:span, actions.join(' | '), :class => 'actions')
    content_for(:banner) do 
      content_tag(:div, content_tag(:h2, actions + h(name)), :id => 'banner') 
    end
  end
  
  def labeled_form_for(*args, &block)
    options = args.extract_options!.merge(:builder => LabeledFormBuilder)
    form_for(*(args + [options]), &block)
  end
  
  def cancel_link(url)
    link_to 'cancel', url, :class => 'destructive'
  end
end
