require 'cgi'

module Betterdoc
  module Containerservice
    module Helpers
      module LinkHelper
        extend ActiveSupport::Concern

        def create_stacker_link(target_path, parameters = {})

          result_url = resolve_stacker_base_url.dup
          result_url << '/' unless result_url.end_with?('/') || target_path.start_with?('/')
          result_url << target_path unless result_url.end_with?('/') && target_path.start_with?('/')
          result_url << target_path[1, target_path.length] if result_url.end_with?('/') && target_path.start_with?('/')

          parameters.each_with_index do |(parameter_name, parameter_value), parameter_index|
            result_url << (parameter_index.zero? && !result_url.include?('?') ? '?' : '&')
            result_url << CGI.escape(parameter_name.to_s) << '=' << CGI.escape(parameter_value.to_s)
          end
          result_url

        end

        private

        def resolve_stacker_base_url
          resolve_stacker_base_url_from_request.presence || resolve_stacker_base_url_from_environment || "/"
        end

        def resolve_stacker_base_url_from_request
          request.headers['HTTP_X-STACKER-ROOT-URL']
        end

        def resolve_stacker_base_url_from_environment
          ENV['STACKER_ROOT_URL']
        end

      end
    end
  end
end
