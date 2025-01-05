module FormHelper
  class CustomFormBuilder < ActionView::Helpers::FormBuilder
    def error_message(attribute)
      return unless object.errors[attribute].any?

      content_tag(:div, object.errors[attribute].join(', '), class: 'text-red-500 text-sm')
    end
  end
end
