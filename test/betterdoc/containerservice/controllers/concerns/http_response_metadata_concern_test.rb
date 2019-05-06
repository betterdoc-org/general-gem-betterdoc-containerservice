require 'test_helper'
require 'openssl'
require 'betterdoc/containerservice/controllers/concerns/http_response_metadata_concern'
require 'betterdoc/containerservice/metadata'

class HttpResponseMetadataConcernTest < ActiveSupport::TestCase

  test "add http response headers" do

    Betterdoc::Containerservice::Metadata.stubs(:compute_name).returns('s-name')
    Betterdoc::Containerservice::Metadata.stubs(:compute_version).returns('s-version')

    response = Object.new
    response.expects(:add_header).with('X-Parc-Service-Metadata', 's-name s-version')

    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::HttpResponseMetadataConcern)
    concern.stubs(:response).returns(response)

    concern.add_http_response_headers

  end

end
