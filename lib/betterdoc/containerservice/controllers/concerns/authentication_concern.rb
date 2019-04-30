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
            if request.params.key?('_jwt')
              request.params['_jwt']
            elsif !request.headers['Authorization']
              ''
            else
              request.headers['Authorization'].split(' ').last
            end
          end

          def authenticate_service_from_token
            return if ENV['JWT_VALIDATION_ENABLED'] == 'false'

            token = extract_authentication_token
            raise AuthenticationConcern::MissingTokenError if token.blank?

            begin
              public_key = OpenSSL::PKey::RSA.new(ENV['JWT_PUBLIC_KEY'])
              JWT.decode(token, public_key, true, algorithm: (ENV['JWT_VALIDATION_ALGORITHM'] || 'RS256'))
            rescue StandardError
              raise AuthenticationConcern::InvalidTokenError
            end
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
