require 'cgi'

module Betterdoc
  module Containerservice
    module Helpers
      module LinkHelper
        extend ActiveSupport::Concern

        def stacker_link_url(target_path, parameters = {})
          result_url = resolve_stacker_base_url.dup
          result_url << '/' unless result_url.end_with?('/') || target_path.start_with?('/')
          result_url << target_path unless result_url.end_with?('/') && target_path.start_with?('/')
          result_url << target_path[1, target_path.length] if result_url.end_with?('/') && target_path.start_with?('/')
          result_url << (result_url.include?('?') ? '&' : '?') unless parameters&.empty?
          result_url << parameters.to_query unless parameters&.empty?
          result_url
        end

        private

        def resolve_stacker_base_url
          resolve_stacker_base_url_from_request.presence || resolve_stacker_base_url_from_environment || "/"
        end

        def resolve_stacker_base_url_from_request
          request.headers['HTTP_X_STACKER_ROOT_URL']
        end

        def resolve_stacker_base_url_from_environment
          ENV['STACKER_ROOT_URL']
        end

      end
    end
  end
end
