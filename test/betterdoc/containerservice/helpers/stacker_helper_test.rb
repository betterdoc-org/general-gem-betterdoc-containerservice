require 'test_helper'
require 'betterdoc/containerservice/helpers/stacker_helper'

class StackerHelperTest < ActiveSupport::TestCase

  test "stacker_request header present" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns('HTTP_X_STACKER_ROOT_URL' => 'http://stacker.example.com')

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Helpers::StackerHelper)

    assert_equal true, concern.stacker_request?
  end

  test "stacker_request header not present" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns('SOME_HEADER' => 'header_value')

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Helpers::StackerHelper)

    assert_equal false, concern.stacker_request?
  end
end
