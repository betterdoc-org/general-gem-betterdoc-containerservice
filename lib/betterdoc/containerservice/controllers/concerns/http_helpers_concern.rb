module Betterdoc
  module Containerservice
    module Controllers
      module Concerns
        module HttpHelpersConcern
          extend ActiveSupport::Concern

          def render_containerservice_error(error_code, error_message)
            Rails.logger.info("Rendering HTTP error #{error_code}: #{error_message}")
            render json: {}, status: error_code, message: error_message
          end

          def render_containerservice_template(template_name)
            render template: template_name, layout: params[:full_html] == 'true' || ENV['CONTAINERSERVICE_FULL_HTML'] == 'true'
          end

        end
      end
    end
  end
end
