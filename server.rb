# frozen_string_literal: true

require 'word-to-markdown'
require 'sinatra'
require 'commonmarker'
require 'tempfile'
require 'rack/host_redirect'
require 'rack/ecg'
require 'secure_headers'
require 'rest_client'

module WordToMarkdownServer
  class App < Sinatra::Base
    use SecureHeaders::Middleware
    SecureHeaders::Configuration.default

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
        %w[word2md.azurewebsites.net www.word2md.com] => 'word2md.com'

    use Rack::ECG, checks: [
      [:static, { name: 'environment', value: Sinatra::Application.environment }],
      [:static, { name: 'word-to-markdown', value: WordToMarkdown::VERSION }],
      [:static, { name: 'soffice', value: WordToMarkdown.soffice.version, success: !WordToMarkdown.soffice.version.nil? }]
    ]

    configure do
      set :root, __dir__
      set :static, true
      set :bind, '0.0.0.0'
      set :port, (ENV.fetch('PORT', nil) || 80)
      set :server, :puma unless development?
    end

    get '/' do
      render_template :index, error: nil, beta: (ENV.fetch('BETA_SERVER', nil) != nil)
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
      beta = ENV.fetch('BETA_SERVER', nil)
      unless params['doc'] && params['doc'][:filename]
        error = 'You must upload a document to convert.'
        status 400
        render_template :index, error: error, beta: (beta != nil)
      end

      unless /docx?$/i.match?(params['doc'][:filename])
        error = 'It looks like you tried to upload something other than a Word Document.'
        status 400
        render_template :index, error: error, beta: (beta != nil)
      end

      md = if ENV.fetch('BETA_SERVER', nil) && params['beta']
             convert_beta(params['doc'][:tempfile])
           else
             convert(params['doc'][:tempfile])
           end

      html = render_html(md)
      name = params['doc'][:filename].force_encoding('UTF-8').sub(/\.docx?$/, '')

      render_template :display, md: md, html: html, filename: name, beta: (beta != nil)
    end

    post '/raw' do
      file = Tempfile.new('word-to-markdown')
      File.write file.path, request.env['rack.request.form_vars']
      convert(file.path)
    end

    not_found do
      status 404
      'Not found'
    end

    private

    def render_template(template, locals = {})
      halt erb template, layout: :layout, locals: locals
    end

    def doc_contents(doc)
      path = File.expand_path "./docs/#{doc}.md", __dir__
      File.read(path)
    end

    def convert_beta(file_path, unlink: true)
      server = ENV.fetch('BETA_SERVER', nil)
      response = RestClient.post("#{server}/raw", doc: File.new(file_path))
      File.unlink(file_path) if unlink
      response.body
    end

    def convert(file_path, unlink: true)
      md = WordToMarkdown.new(file_path).to_s
      File.unlink(file_path) if unlink
      md
    end

    def render_html(markdown)
      extensions = %i[table strikethrough]
      CommonMarker.render_html(markdown, :DEFAULT, extensions)
    end
  end
end
