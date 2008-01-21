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

      # TODO: Document this.
      #
      # Produces a dynamically expandable list of <select> tags.
      #
      def select_many_from_list(attribute, collection, require_one_selection = true, value_method = :id, text_method = :name)
        fieldset_name = "#{object_name}_#{attribute.to_s.pluralize}"
        selected_objects = object.send(attribute)
        html = %Q(<fieldset id="#{fieldset_name}">)
        html << %Q(<legend>#{attribute.to_s.humanize}</legend>)
        if selected_objects.empty?
          html << selection_without_remove_link(attribute, collection, value_method, text_method)
        else
          selected_objects.each_with_index do |selected_object, index|
            if index == 0 && require_one_selection
              html << selection_without_remove_link(attribute, collection, value_method, text_method, selected_object)
            else
              html << selection_with_remove_link(attribute, collection, value_method, text_method, selected_object)
            end
          end
        end

        html +=<<-HTML
        <script type="text/javascript">
        var insertSelectionWithRemoveLink = function(element) {
          element.up().insert({ before: '#{selection_with_remove_link(attribute, collection, value_method, text_method)}' });
        }
        </script>
        <div>
          <a href="#" onclick="javascript:insertSelectionWithRemoveLink($(this)); return false">+</a>
        </div></fieldset>
        HTML
      end

      def submit_tag
        %Q(<input type="submit" value="#{object.new_record? ? "Create" : "Update" }" />)
      end

      private
      def selection_without_remove_link(attribute, collection, value_method, text_method, selected_object)
        selection = %Q(<div>#{build_selection_for_multiple_collection_select(attribute, collection, value_method, text_method, selected_object)}</div>)
      end

      def selection_with_remove_link(attribute, collection, value_method, text_method, selected_object = nil)
        selection = %Q(<div>#{build_selection_for_multiple_collection_select(attribute, collection, value_method, text_method, selected_object)}<a href="#" onclick="javascript:$(this).up().remove(); return false">-</a></div>)
      end

      def build_selection_for_multiple_collection_select(attribute, collection, value_method, text_method, selected_object)
        selection = %Q(<select name="#{object_name}[#{attribute.to_s.singularize}_ids][]">)
        collection.each do |option|
          selection << %Q(<option value="#{option.id}")
          if !selected_object.blank? && option.send(value_method) == selected_object.send(value_method)
            selection << %Q( selected="selected")
          end
          selection << %Q(>#{option.send(text_method)}</option>)
        end
        selection << %Q(</select>)
      end
    end
  end
end