require 'test_helper'
require 'betterdoc/containerservice/helpers/event_label_helper'

class EventLabelHelperTest < ActiveSupport::TestCase
  include Betterdoc::Containerservice::Helpers::EventLabelHelper

  test "correctly evaluates event as essential" do
    assert essential?('DID_RECEIVE_LEAD')
    assert essential?('DID_RECEIVE_FULL_ANAMNESIS_SURVEY')
    assert essential?('DID_RECEIVE_FULL_ANAMNESIS_SURVEY')

    refute essential?('DID_UPDATE_CASE_LEAD')
    refute essential?('DID_UPDATE_CASE_INQUIRY')
    refute essential?('DID_UPDATE_CASE_INTENT')
  end

  test "returns proper label for event" do
    assert_equal get_event_label('DID_RECEIVE_LEAD'), 'Lead erstellt'
    assert_equal get_event_label('DID_UPDATE_CASE_LEAD'), '(Non-essential event has no label.)'
  end

  test "returns proper phase for event" do
    assert_equal get_current_phase(events), 'Admission'
  end

  test "lists all phases" do
    assert all_phases.is_a?(Array)
    assert_equal all_phases.count, 5
  end

  private

  def events
    [
      {
        "id" => "43d4dac6-6b98-4ce7-b9dd-b74f449e9393",
        "type" => "DID_SCHEDULE_ADMISSION_CALL",
        "timestamp" => "2019-08-12T15:52:55+02:00",
        "timestamp_DID_SCHEDULE_ADMISSION_CALL" => "2019-08-12T15:52:55+02:00"
      },
      {
        "id" => "f520c70b-68bd-4b6b-8ebb-e5ddcb8bdf54",
        "timestamp_DID_RECEIVE_LEAD" => "2019-08-12T15:52:55+02:00",
        "type" => "DID_RECEIVE_LEAD",
        "timestamp" => "2019-08-12T15:12:55+02:00"
      }
    ]
  end

end
