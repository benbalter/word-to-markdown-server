require 'word-to-markdown'
require 'sinatra'
require 'html/pipeline'
require 'rack/coffee'
require 'tempfile'

module WordToMarkdownServer
  class App < Sinatra::Base

    helpers do
      def html_escape(text)
        Rack::Utils.escape_html(text)
      end
    end

    use Rack::Coffee, root: 'public', urls: '/assets/javascripts'

    get "/" do
      render_template :index, { :error => nil }
    end

    post "/" do
      unless params['doc'][:filename].match /docx?$/i
        error = "It looks like you tried to upload something other than a Word Document."
        render_template :index, { :error => error }
      end
      md = WordToMarkdown.new(params['doc'][:tempfile]).to_s
      html = HTML::Pipeline::MarkdownFilter.new(md).call
      render_template :display, { :md => md, :html => html, :filename => params['doc'][:filename].sub(/\.docx?$/,"") }
    end

    post "/raw" do
      file = Tempfile.new('word-to-markdown')
      file.write request.env["rack.request.form_vars"]
      WordToMarkdown.new(file.path).to_s
      file.close
      file.unlink
    end

    def render_template(template, locals={})
      halt erb template, :layout => :layout, :locals => locals
    end

  end
end
