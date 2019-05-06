# frozen_string_literal: true

require 'word-to-markdown'
require 'sinatra'
require 'commonmarker'
require 'tempfile'
require 'sprockets'
require 'uglifier'
require 'sass'
require 'bootstrap'
require 'autoprefixer-rails'
require 'rack/host_redirect'

module WordToMarkdownServer
  class App < Sinatra::Base
    helpers do
      def html_escape(text)
        Rack::Utils.escape_html(text)
      end

      def site_title
        'Word to Markdown Converter'
      end

      def description
        'Convert Word or Google documents to Markdown online'
      end

      def url
        'https://word2md.com'
      end

      def nav_links
        {
          'Feedback' => 'https://github.com/benbalter/word-to-markdown/blob/master/docs/CONTRIBUTING.md',
          'Source' => 'https://github.com/benbalter/word-to-markdown',
          'Donate' => 'https://www.patreon.com/benbalter',
          'Terms' => '/terms/',
          'Privacy' => '/privacy/',
          '@benbalter' => 'https://ben.balter.com'
        }
      end
    end

    use Rack::HostRedirect,
        'word-to-markdown.herokuapp.com' => 'word2md.com'

    configure do
      set :bind, '0.0.0.0'
      set :port, (ENV['PORT'] || 5000)
      set :server, :puma unless development?
      set :environment, Sprockets::Environment.new
      environment.append_path 'assets/stylesheets'
      environment.append_path 'assets/javascripts'
      environment.js_compressor  = :uglify
      environment.css_compressor = :scss
      AutoprefixerRails.install(environment)
    end

    get '/' do
      render_template :index, error: nil
    end

    get '/terms/' do
      md   = doc_contents(:terms)
      html = render_html(md)
      render_template :doc, body: html, page_title: 'Terms of Use'
    end

    get '/privacy/' do
      md   = doc_contents(:privacy)
      html = render_html(md)
      render_template :doc, body: html, page_title: 'Your privacy'
    end

    post '/' do
      unless params['doc'] && params['doc'][:filename]
        error = 'You must upload a document to convert.'
        status 400
        render_template :index, error: error
      end

      unless /docx?$/i.match?(params['doc'][:filename])
        error = 'It looks like you tried to upload something other than a Word Document.'
        status 400
        render_template :index, error: error
      end

      md   = convert(params['doc'][:tempfile])
      html = render_html(md)

      render_template :display, md: md, html: html, filename: params['doc'][:filename].sub(/\.docx?$/, '')
    end

    post '/raw' do
      file = Tempfile.new('word-to-markdown')
      File.write file.path, request.env['rack.request.form_vars']
      convert(file.path)
    end

    get '/assets/*' do
      env['PATH_INFO'].sub!('/assets', '')
      settings.environment.call(env)
    end

    private

    def render_template(template, locals = {})
      halt erb template, layout: :layout, locals: locals
    end

    def doc_contents(doc)
      path = File.expand_path "./docs/#{doc}.md", __dir__
      File.read(path)
    end

    def convert(file_path, unlink: true)
      md = WordToMarkdown.new(file_path).to_s
      File.unlink(file_path) if unlink
      CGI.escapeHTML(md)
    end

    def render_html(markdown)
      extensions = %i[table strikethrough]
      CommonMarker.render_html(markdown, :DEFAULT, extensions)
    end
  end
end
