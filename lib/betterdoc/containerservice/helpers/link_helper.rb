require 'cgi'

module Betterdoc
  module Containerservice
    module Helpers
      module LinkHelper
        extend ActiveSupport::Concern

        # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
        def create_stacker_link(target_path, parameters = {})

          base_url_from_request = resolve_stacker_base_url_from_request
          base_url_from_environment = resolve_stacker_base_url_from_environment
          base_url = base_url_from_request if base_url_from_request.present?
          base_url = base_url_from_environment if base_url.blank? && base_url_from_environment.present?
          base_url = '/' if base_url.blank?

          result_url = base_url.dup
          result_url << '/' unless base_url.end_with?('/') || target_path.start_with?('/')
          result_url << target_path unless result_url.end_with?('/') && target_path.start_with?('/')
          result_url << target_path[1, target_path.length] if result_url.end_with?('/') && target_path.start_with?('/')

          parameters.each_with_index do |(parameter_name, parameter_value), parameter_index|
            result_url << (parameter_index.zero? && !result_url.include?('?') ? '?' : '&')
            result_url << CGI.escape(parameter_name.to_s) << '=' << CGI.escape(parameter_value.to_s)
          end
          result_url

        end
        # rubocop:enable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity

        private

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
