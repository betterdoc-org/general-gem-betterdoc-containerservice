module Betterdoc
  module Containerservice
    module Helpers
      module EventLabelHelper
        extend ActiveSupport::Concern
        ESSENTIAL_EVENTS = YAML.safe_load(File.open(File.expand_path('../data/event_labels.yml', File.dirname(__FILE__))))

        def essential?(event)
          return true if ESSENTIAL_EVENTS.key?(event)

          false
        end

        def get_event_label(event)
          return ESSENTIAL_EVENTS[event]['label'] if ESSENTIAL_EVENTS.key?(event)

          '(Non-essential event has no label.)'
        end

        def get_current_phase(all_events)
          all_events.reverse_each do |event|
            event = event['type']
            if ESSENTIAL_EVENTS.key?(event)
              current_phase = ESSENTIAL_EVENTS[event]['phase']
              return current_phase unless current_phase.nil?
            end
          end

          false
        end

        def all_phases
          phases = []
          ESSENTIAL_EVENTS.each do |event|
            phases.push(event[1]['phase'])
          end
          phases = phases.uniq
          phases.delete('')
          phases
        end
      end
    end
  end
end
