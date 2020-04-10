# frozen_string_literal: true

RSpec.describe WordToMarkdownServer::App do
  let(:binary) { true }
  let(:fixture) { 'document.docx' }
  let(:file_path) { File.expand_path "./fixtures/#{fixture}", __dir__ }
  let(:filetype) { 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' }
  let(:document) { Rack::Test::UploadedFile.new(file_path, filetype, binary) }

  it 'loads the landing page' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('as easy as 1, 2, 3...')
  end

  it 'renders to terms' do
    get '/terms/'
    expected = '<strong>This Service is provided &quot;as is&quot;'
    expect(last_response).to be_ok
    expect(last_response.body).to include(expected)
  end

  it 'renders the privacy policy' do
    get '/privacy/'
    expected = '<h2>Information collected</h2>'
    expect(last_response).to be_ok
    expect(last_response.body).to include(expected)
  end

  it 'converts a document' do
    post '/', doc: document
    expect(last_response).to be_ok

    expected = 'This is **a** _test_.'
    expect(last_response.body).to include(expected)

    expected = '<p>This is <strong>a</strong> <em>test</em>.</p>'
    expect(last_response.body).to include(expected)
  end

  context 'with a non doc/docx file' do
    let(:fixture)  { 'file.txt' }
    let(:filetype) { 'text/plain' }

    it 'errs' do
      post '/', doc: document
      expect(last_response).not_to be_ok
      expected = 'you tried to upload something other than a Word Document'
      expect(last_response.body).to include(expected)
    end
  end

  it 'errs with no doc' do
    post '/'
    expect(last_response).not_to be_ok
    expected = 'You must upload a document to convert'
    expect(last_response.body).to include(expected)
  end

  it 'returns JS' do
    get '/assets/app.js'
    expect(last_response).to be_ok
    expected = 'new ClipboardJS("#copy-button")'
    expect(last_response.body).to include(expected)
  end

  it 'returns css' do
    get '/assets/style.css'
    expect(last_response).to be_ok
    expected = '-webkit-user-select:all'
    expect(last_response.body).to include(expected)
  end
end
