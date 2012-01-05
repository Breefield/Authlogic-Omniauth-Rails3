class LabeledFormBuilder < ActionView::Helpers::FormBuilder
  
  delegate :content_tag, :tag, to: :@template
  
  def error_messages
    if object.errors.full_messages.any?
      content_tag(:div, :class => "error_messages alert-message error") do
        content_tag(:h3, "Invalid Fields") +
        content_tag(:ul, :class => "unstyled") do
          object.errors.full_messages.map do |msg|
            content_tag(:li, msg)
          end.join.html_safe
        end
      end
    end
  end
end