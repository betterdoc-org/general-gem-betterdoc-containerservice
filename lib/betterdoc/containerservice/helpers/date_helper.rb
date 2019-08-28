module Betterdoc
  module Containerservice
    module Helpers
      module DateHelper
        extend ActiveSupport::Concern

        def get_formatted_datetime(date)
          return 'N/A' if date.nil? || date == 'N/A'

          Time.parse(date).strftime('%d.%m.%Y %H:%M')
        end

        def get_formatted_date(date)
          return 'N/A' if date.nil? || date == 'N/A'

          Time.parse(date).strftime('%d.%m.%Y')
        end

        def date_in_future_or_today(date)
          date = Time.parse(date)
          date.future? || date.today?
        end

        def sort_by_date(arr, column, direction = 'DESC')
          sorted = arr.sort_by { |el| Time.parse(el[column]).utc.to_i }
          if direction == 'DESC'
            sorted.reverse
          else
            sorted
          end
        end
      end
    end
  end
end
