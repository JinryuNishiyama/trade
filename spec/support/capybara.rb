require 'capybara/rspec'

Capybara.register_driver :remote_chrome do |app|
  url = ENV['SELENIUM_DRIVER_URL']
  caps = ::Selenium::WebDriver::Remote::Capabilities.chrome(
    'goog:chromeOptions' => {
      'args' => [
        'headless',
        'no-sandbox',
        'disable-gpu',
        'window-size=1400,1400',
      ],
    }
  )
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: url,
    desired_capabilities: caps
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.app_host = "http://#{Capybara.server_host}"
    driven_by :remote_chrome
  end
end
