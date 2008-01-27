module ApplicationHelper
  [ :form_for, :fields_for, :form_remote_for, :remote_form_for ].each do |form_helper|
    xeriom_form_helper = <<-CODE
    def xeriom_#{form_helper}(object_name, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.update(:builder => Xeriom::Form::LabellingFormBuilder)
      #{form_helper}(object_name, *(args << options), &block)
    end
    CODE
    module_eval xeriom_form_helper, __FILE__, __LINE__
  end

  # A very easy way to build forms for applicaitons that use 
  # ResourcesController.
  #
  def xeriom_form_for_resource(*args, &block)
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.update(:url => resource_url)
    xeriom_form_for(resource, *(args << options), &block)
  end

  # Provide "odd" followed by "even" in a cycle in the current binding.
  #
  # It's important to do this in a single binding as it means we can use 
  # <code>alternate_rows</code> in a row partial and not have it return "odd"
  # all the time - <code>cycle</code> uses the current binding to choose which
  # value to return.
  #
  def alternate_rows
    cycle("odd", "even")
  end

  # Get a string suitable for use as a page title.
  #
  def page_title
    if defined?(@page_title)
      @page_title
    else
      action = case controller.action_name
      when "edit"
        "Edit"
      when "new"
        "Create a"
      else
        ""
      end

      @page_title = h(
      if !respond_to?(:enclosing_resource?) || enclosing_resource.blank?
        "#{action} #{name_of_resource}"
      else
        "#{action} #{name_of_resource} associated with #{name_of_enclosing_resource}"
      end
      )
    end
  end

  # Get the name of the current resource.
  #
  def name_of_resource(resource_object = nil)
    resource_object ||= respond_to?(:resource) ? resource : nil
    if resource_object.respond_to?(:name)
      (resource_object.new_record? || resource_object.name.blank?) ? "new #{controller.controller_name.singularize.humanize.downcase}" : resource_object.name
    elsif resource_object.nil?
      controller.controller_name.humanize
    else
      "#{controller.controller_name.singularize.humanize} #{resource_object.id}"
    end
  end

  # Get the name if the enclosing resource, if any.
  #
  def name_of_enclosing_resource
    name_of_resource(enclosing_resource)
  end

  # Provide a simple way of entering "call me" links in the same manner as
  # <code>mail_to</code>.
  def call_to(text, number = nil)
    text = "UNKNOWN" if text.blank?
    number = text if number.blank?
    link_to text, "callto://#{number}"
  end

  # Get the flash messages.
  #
  def flash_messages
    flash.sort.collect do |level, message|
      content_tag(:p, message, :class => "flash #{level}", :id => "flash_#{level}")
    end.join("\n  ")
  end
end