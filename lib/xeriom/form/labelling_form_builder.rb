module Xeriom
  module Form
    class LabellingFormBuilder < ActionView::Helpers::FormBuilder
      def label_for(field)
        %Q(<label for="#{object_name}_#{field}">#{field.to_s.humanize}</label>)
      end

      %W( check_box radio_button ).each do |form_tag_helper|
        xeriom_form_tag_helper = <<-CODE
        def #{form_tag_helper}_with_label(field, *args)
          %Q(<div class="#{form_tag_helper}">\#{#{form_tag_helper}_without_label(field, *args)}\#{label_for(field)}</div>)
        end
        alias_method_chain :#{form_tag_helper}, :label
        CODE
        class_eval xeriom_form_tag_helper, __FILE__, __LINE__
      end

      %W( collection_select country_select date_select datetime_select 
      password_field select text_area text_field time_select time_zone_select ).each do |form_tag_helper|
        xeriom_form_tag_helper = <<-CODE
        def #{form_tag_helper}_with_label(field, *args)
          %Q(<div class="#{form_tag_helper}">\#{label_for(field)}\#{#{form_tag_helper}_without_label(field, *args)}</div>)
        end
        alias_method_chain :#{form_tag_helper}, :label
        CODE
        class_eval xeriom_form_tag_helper, __FILE__, __LINE__
      end
      
      def submit_tag
        %Q(<input type="submit" value="#{object.new_record? ? "Create" : "Update" }" />)
      end
    end
  end
end
