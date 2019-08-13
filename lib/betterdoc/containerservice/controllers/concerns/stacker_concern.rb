module Betterdoc
  module Containerservice
    module Controllers
      module Concerns
        module StackerConcern
          extend ActiveSupport::Concern

          included do
            helper_method :stacker_request?
          end

          def stacker_request?
            request.headers['HTTP_X_STACKER_ROOT_URL'].present?
          end
        end
      end
    end
  end
end
