require 'active_support/core_ext/numeric/time'
require 'test_helper'
require 'openssl'
require 'betterdoc/containerservice/controllers/concerns/authentication_concern'

class AuthenticationConcernTest < ActiveSupport::TestCase

  test "extract authentication token from request" do

    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::AuthenticationConcern)
    configure_concern_request(concern, params: { '_jwt' => 'token_from_request' })

    assert_equal 'token_from_request', concern.extract_authentication_token

  end

  test "extract authentication token from header" do

    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::AuthenticationConcern)
    configure_concern_request(concern, headers: { 'Authorization' => 'Bearer token_from_header' })

    assert_equal 'token_from_header', concern.extract_authentication_token

  end

  test "extract authentication token nothing found" do

    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::AuthenticationConcern)
    configure_concern_request(concern, params: {}, headers: {})

    assert_equal '', concern.extract_authentication_token

  end

  test "authenticate service from token with valid token" do

    concern = Object.new
    concern.extend(Betterdoc::Containerservice::Controllers::Concerns::AuthenticationConcern)
    configure_concern_jwt(concern)
    configure_concern_request(concern, params: { '_jwt' => create_valid_jwt }, headers: {})

    assert_not_empty concern.authenticate_service_from_token

  end

  test "authenticate service from token with invalid token" do
    assert_raises Betterdoc::Containerservice::Controllers::Concerns::AuthenticationConcern::InvalidTokenError do
      concern = Object.new
      concern.extend(Betterdoc::Containerservice::Controllers::Concerns::AuthenticationConcern)
      configure_concern_jwt(concern)
      configure_concern_request(concern, params: { '_jwt' => 'INVALID' }, headers: {})
      concern.authenticate_service_from_token
    end
  end

  test "authenticate service from token with empty token" do
    assert_raises Betterdoc::Containerservice::Controllers::Concerns::AuthenticationConcern::MissingTokenError do
      concern = Object.new
      concern.extend(Betterdoc::Containerservice::Controllers::Concerns::AuthenticationConcern)
      configure_concern_jwt(concern)
      configure_concern_request(concern, params: {}, headers: {})
      concern.authenticate_service_from_token
    end
  end

  private

  def configure_concern_request(concern, request_properties)

    request = Object.new
    request_properties.each do |key, value|
      request.stubs(key).returns(value)
    end

    concern.stubs(:request).returns(request)

  end

  def configure_concern_jwt(concern)
    concern.stubs(:compute_jwt_validation_enabled).returns(true)
    concern.stubs(:compute_jwt_public_key).returns(dummy_jwt_public_key)
  end

  def create_valid_jwt
    private_key = OpenSSL::PKey::RSA.new(dummy_jwt_private_key)
    JWT.encode({ exp: (Time.now + 1.hour).utc.to_i }, private_key, 'RS256')
  end

  def dummy_jwt_private_key
    "-----BEGIN RSA PRIVATE KEY-----\n" \
    "MIIBOQIBAAJBALkkRpm1jBi6how76ESNfCXUmibWSXZsPVPvPZa2UjZWO9020FUl\n" \
    "YkiNxMdBeGvhB2ejaJQKOZLXX4YnHcSPOCcCAwEAAQJAeN4O3VBhes9jAXAmzYJU\n" \
    "t1nZnVsuMIqvavl4CslSWLfM4w4wvhVVMnWtzm+JspP4Jt9/cdIDpn2oJEv4sVT/\n" \
    "CQIhAOQE/sdjYqBYtoOO3UABR/uVHVEPOJqN/noFcLbk86IrAiEAz9xRKpyCPijb\n" \
    "geNjoJGfpDoDzqtA5Ekp98U4yUrtj/UCICDnO6CoDcZXptarGfAvfySlqtpUmPVs\n" \
    "ggk3mcE6npGLAiB5VbJLnXCpuE/qUkIlyNvXkcYHLhCDMfI9n/K2Dfb+wQIgBl/N\n" \
    "Gsae60WF6YT7aruMzNCi/m0mBitYZvltxh4+GZU=\n" \
    "-----END RSA PRIVATE KEY-----\n"
  end

  def dummy_jwt_public_key
    "-----BEGIN PUBLIC KEY-----\n" \
    "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALkkRpm1jBi6how76ESNfCXUmibWSXZs\n" \
    "PVPvPZa2UjZWO9020FUlYkiNxMdBeGvhB2ejaJQKOZLXX4YnHcSPOCcCAwEAAQ==\n" \
    "-----END PUBLIC KEY-----\n"
  end

end
