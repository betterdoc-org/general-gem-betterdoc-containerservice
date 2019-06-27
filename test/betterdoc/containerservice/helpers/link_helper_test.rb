require 'test_helper'
require 'betterdoc/containerservice/helpers/link_helper'

class LinkHelperTest < ActiveSupport::TestCase

  test "create stacker link with root url as header" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns({'HTTP_X-STACKER-ROOT-URL' => 'http://stacker.example.com'})

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Helpers::LinkHelper)

    assert_equal 'http://stacker.example.com/stacks/abc', concern.create_stacker_link('stacks/abc')

  end

  test "create stacker link with root url as header and parameters with special characters" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns({'HTTP_X-STACKER-ROOT-URL' => 'http://stacker.example.com'})

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Helpers::LinkHelper)

    assert_equal 'http://stacker.example.com/stacks/abc?aKey=%2Faaa&bKey=%26bbb', concern.create_stacker_link('stacks/abc', 'aKey' => '/aaa', 'bKey' => '&bbb')

  end

  test "create stacker link with root url as header and parameters" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns({'HTTP_X-STACKER-ROOT-URL' => 'http://stacker.example.com'})

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Helpers::LinkHelper)

    assert_equal 'http://stacker.example.com/stacks/abc?aKey=aValue&bKey=bValue', concern.create_stacker_link('stacks/abc', 'aKey' => 'aValue', 'bKey' => 'bValue')

  end

  test "create stacker link with root url as header and parameters slash both in root URL and path" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns({'HTTP_X-STACKER-ROOT-URL' => 'http://stacker.example.com/'})

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Helpers::LinkHelper)

    assert_equal 'http://stacker.example.com/stacks/abc?aKey=aValue&bKey=bValue', concern.create_stacker_link('/stacks/abc', 'aKey' => 'aValue', 'bKey' => 'bValue')

  end

  test "create stacker link with root url as header and parameters no slash in root URL or path" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns({'HTTP_X-STACKER-ROOT-URL' => 'http://stacker.example.com'})

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Helpers::LinkHelper)

    assert_equal 'http://stacker.example.com/stacks/abc?aKey=aValue&bKey=bValue', concern.create_stacker_link('stacks/abc', 'aKey' => 'aValue', 'bKey' => 'bValue')

  end

  test "create stacker link with root url as environment variable and parameters" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns({})

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.stubs(:resolve_stacker_base_url_from_environment).returns('http://stacker-env.example.com/')
    concern.extend(Betterdoc::Containerservice::Helpers::LinkHelper)

    assert_equal 'http://stacker-env.example.com/stacks/abc?aKey=aValue&bKey=bValue&cKey=', concern.create_stacker_link('stacks/abc', 'aKey' => 'aValue', 'bKey' => 'bValue', 'cKey' => nil)

  end

  test "create stacker link with default root url and parameters" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns({})

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Helpers::LinkHelper)

    assert_equal '/stacks/abc?aKey=aValue&bKey=bValue', concern.create_stacker_link('stacks/abc', 'aKey' => 'aValue', 'bKey' => 'bValue')

  end

  test "create stacker link with default root url and parameters as symbols" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns({})

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.extend(Betterdoc::Containerservice::Helpers::LinkHelper)

    assert_equal '/stacks/abc?aKey=aValue&bKey=bValue', concern.create_stacker_link('stacks/abc', aKey: 'aValue', bKey: 'bValue')

  end

  test "create stacker link with default root url and parameters both in path and explicit" do

    mocked_request = Object.new
    mocked_request.stubs('headers').returns({'HTTP_X-STACKER-ROOT-URL' => 'http://stacker.example.com'})

    concern = Object.new
    concern.stubs(:request).returns(mocked_request)
    concern.stubs(:resolve_stacker_base_url_from_environment).returns('http://stacker-env.example.com/')
    concern.extend(Betterdoc::Containerservice::Helpers::LinkHelper)

    assert_equal 'http://stacker.example.com/stacks/abc?x=y&aKey=aValue&bKey=bValue', concern.create_stacker_link('stacks/abc?x=y', 'aKey' => 'aValue', 'bKey' => 'bValue')

  end

end
