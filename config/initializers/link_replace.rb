# frozen_string_literal: true

module ActionView
  class Template
    def render(view, locals, buffer = ActionView::OutputBuffer.new, &block)
      body = instrument_render_template do
        compile!(view)
        view._run(method_name, self, locals, buffer, &block)
      end
      doc = Nokogiri::HTML(body)
      doc.css("img").each do |img|
        if img["src"]
          img["src"] = img["src"].gsub("http://lh3.googleusercontent.com/", ENV.fetch("IMG_PROXY") { "https://lh3.googleusercontent.com/" })
        end
      end
      doc.to_s
    rescue => e
      handle_render_error(view, e)
    end
  end
end
