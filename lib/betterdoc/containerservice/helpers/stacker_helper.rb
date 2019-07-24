module Betterdoc
  module Containerservice
    module Helpers
      module StackerHelper

        def stacker_request?
          request.headers['HTTP_X_STACKER_ROOT_URL'].present?
        end

      end
    end
  end
end
