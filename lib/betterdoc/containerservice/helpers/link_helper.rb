require 'cgi'
require 'action_view/helpers'

module Betterdoc
  module Containerservice
    module Helpers
      module LinkHelper
        extend ActiveSupport::Concern
        include ActionView::Helpers::UrlHelper

        def link_to_stack(content, stack, url_options = {}, html_options = {})
          stack_url = stacker_link_url("stacks/#{stack}", url_options)
          html_options[:data] ||= {}
          html_options[:data][:stacker_no_hijack] = "true"
          link_to(content, stack_url, html_options)
        end

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
          resolve_stacker_base_url_from_request.presence || resolve_stacker_base_url_from_environment.presence || "/"
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
