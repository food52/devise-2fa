require 'spec_helper'
require 'integration_tests_helper'

class TokenTest < ActionDispatch::IntegrationTest
  def teardown
    Capybara.reset_sessions!
  end

  test 'disabling OTP after successfully enabling' do
    # log in 1fa
    user = enable_otp_and_sign_in
    current_path.should eq user_credential_path
    # otp two_factor
    fill_in 'user_token', with: ROTP::TOTP.new(user.otp_auth_secret).at(Time.now)
    click_button 'Submit Token'
    current_path.should eq root_path
    # disable OTP
    disable_otp

    # logout
    sign_out

    # log back in 1fa
    sign_user_in(user)

    current_path.should eq root_path
  end
end
