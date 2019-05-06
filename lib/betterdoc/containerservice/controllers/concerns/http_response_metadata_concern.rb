require 'betterdoc/containerservice/metadata'

module Betterdoc
  module Containerservice
    module Controllers
      module Concerns
        module HttpResponseMetadataConcern
          extend ActiveSupport::Concern

          included do
            before_action :add_http_response_headers
          end

          def add_http_response_headers
            response.add_header('X-Parc-Service-Metadata', "#{Betterdoc::Containerservice::Metadata.compute_name} #{Betterdoc::Containerservice::Metadata.compute_version}")
          end

        end
      end
    end
  end
end
