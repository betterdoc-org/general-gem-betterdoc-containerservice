require 'test_helper'
require 'openssl'
require 'betterdoc/containerservice/controllers/concerns/http_helpers_concern'

class HttpHelpersConcernTest < ActiveSupport::TestCase

  test "render containerservice error" do

    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::HttpHelpersConcern)
    concern.stubs(:render_containerservice_error_log)
    concern.expects(:render).with { |value| value[:status] == 'e_code' && value[:message] == 'e_message' }

    concern.render_containerservice_error('e_code', 'e_message')

  end

  test "render containerservice template" do

    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::HttpHelpersConcern)
    concern.stubs(:params).returns({})
    concern.expects(:render).with { |value| value[:template] == 'template' && value[:layout] == false }

    concern.render_containerservice_template('template')

  end

  test "render containerservice template full HTML from request" do

    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::HttpHelpersConcern)
    concern.stubs(:params).returns(full_html: 'true')
    concern.expects(:render).with { |value| value[:template] == 'template' && value[:layout] == true }

    concern.render_containerservice_template('template')

  end

  test "render containerservice template full HTML from environment" do

    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::HttpHelpersConcern)
    concern.stubs(:params).returns({})
    concern.expects(:render).with { |value| value[:template] == 'template' && value[:layout] == true }

    ClimateControl.modify CONTAINERSERVICE_FULL_HTML: "true" do
      concern.render_containerservice_template('template')
    end
  end

  test "render containerservice action" do
    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::HttpHelpersConcern)
    concern.stubs(:params).returns({})
    concern.expects(:render).with(:action_name, layout: false)

    concern.render_containerservice_action(:action_name)
  end

  test "render containerservice action with full html from request" do
    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::HttpHelpersConcern)
    concern.stubs(:params).returns(full_html: "true")
    concern.expects(:render).with(:action_name, layout: true)

    concern.render_containerservice_action(:action_name)
  end

  test "render containerservice action with full html from environment" do
    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::HttpHelpersConcern)
    concern.stubs(:params).returns({})
    concern.expects(:render).with(:action_name, layout: true)

    ClimateControl.modify CONTAINERSERVICE_FULL_HTML: "true" do
      concern.render_containerservice_action(:action_name)
    end
  end
end
