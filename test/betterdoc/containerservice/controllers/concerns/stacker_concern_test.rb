require 'test_helper'
require 'betterdoc/containerservice/controllers/concerns/stacker_concern'

class StackerHelperTest < ActiveSupport::TestCase

  test "stacker_request header present" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns('HTTP_X_STACKER_ROOT_URL' => 'http://stacker.example.com')

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::StackerConcern)

    assert_equal true, concern.stacker_request?
  end

  test "stacker_request header not present" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns('SOME_HEADER' => 'header_value')

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::StackerConcern)

    assert_equal false, concern.stacker_request?
  end
end
