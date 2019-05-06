require 'openssl'
require 'jwt'

module Betterdoc
  module Containerservice
    module Controllers
      module Concerns
        module AuthenticationConcern
          extend ActiveSupport::Concern

          included do
            before_action :authenticate_service_from_token
            rescue_from AuthenticationConcern::MissingTokenError, with: :rescue_from_missing_token
            rescue_from AuthenticationConcern::InvalidTokenError, with: :rescue_from_invalid_token
          end

          def extract_authentication_token
            if request.respond_to?(:params) && request.params.key?('_jwt')
              request.params['_jwt']
            elsif request.respond_to?(:headers) && request.headers['Authorization']
              request.headers['Authorization'].split(' ').last
            else
              ''
            end
          end

          def authenticate_service_from_token
            return unless compute_jwt_validation_enabled

            token = extract_authentication_token
            raise AuthenticationConcern::MissingTokenError if token.blank?

            begin
              public_key = OpenSSL::PKey::RSA.new(compute_jwt_public_key)
              JWT.decode(token, public_key, true, algorithm: compute_jwt_validation_algorithm)
            rescue StandardError
              raise AuthenticationConcern::InvalidTokenError
            end
          end

          def compute_jwt_validation_enabled
            ENV['JWT_VALIDATION_ENABLED'] != 'false'
          end

          def compute_jwt_public_key
            ENV['JWT_PUBLIC_KEY']
          end

          def compute_jwt_validation_algorithm
            ENV['JWT_VALIDATION_ALGORITHM'] || 'RS256'
          end

          def rescue_from_missing_token
            render_containerservice_error(401, 'No JWT available')
          end

          def rescue_from_invalid_token
            render_containerservice_error(403, 'Invalid JWT')
          end

          class InvalidTokenError < StandardError; end
          class MissingTokenError < StandardError; end

        end
      end
    end
  end
end
