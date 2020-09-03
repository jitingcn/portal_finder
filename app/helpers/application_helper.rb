# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def pagy_url_for(page, pagy)
    params = request.query_parameters.merge(:only_path => true, pagy.vars[:page_param] => page )
    url_for(params)
  end

  def notice_message
    flash_messages = []

    close_html = %(
      <button class="absolute top-0 bottom-0 right-0 px-4 py-3" data-action="application#hidden">
        <svg class="fill-current h-6 w-6 text-red-500" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
          <title>Close</title>
          <path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/>
        </svg>
      </button>
    )

    flash.each do |type, message|
      type_class = ''
      type_class = 'bg-green-100 border-green-400 text-green-700' if type.to_sym == :notice
      type_class = 'bg-red-100 border-red-400 text-red-700' if type.to_sym == :alert
      message_tag = content_tag(:strong, message, class: 'font-medium mr-3')
      text = content_tag(:div, message_tag + raw(close_html),
                         class: "border w-full mb-3 px-4 py-3 rounded relative #{type_class}",
                         role: 'alert', 'data-controller': 'application')
      flash_messages << text if message
    end

    flash_messages.join("\n").html_safe
  end

  def current_route
    "#{params[:controller]}##{params[:action]}"
  end
end
