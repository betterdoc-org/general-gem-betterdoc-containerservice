require 'test_helper'
require 'betterdoc/containerservice/helpers/date_helper'

class DateHelperTest < ActiveSupport::TestCase
  include Betterdoc::Containerservice::Helpers::DateHelper

  test "properly formats dates and datetime" do
    assert_equal get_formatted_datetime(nil), 'Datum nicht verfügbar'
    assert_equal get_formatted_date(nil), 'Datum nicht verfügbar'
    assert_equal get_formatted_datetime('2019-08-12T15:52:55+02:00'), '12.08.2019 15:52'
    assert_equal get_formatted_date('2019-08-12T15:52:55+02:00'), '12.08.2019'
  end

  test "determines is date today or in the future" do
    assert date_in_future_or_today(Time.now.to_s)
    assert date_in_future_or_today((Time.now + 1.day).to_s)
    refute date_in_future_or_today((Time.now - 1.day).to_s)
  end

  test "sorts array of hashes by date on selected column" do
    assert_equal sort_by_date(sample_array, 'timestamp').first['desc'], 'LATER_ONE'
    assert_equal sort_by_date(sample_array, 'timestamp', 'ASC').first['desc'], 'EARLIER_ONE'
  end

  private

  def sample_array
    [
      {
        "desc" => "EARLIER_ONE",
        "timestamp" => "2019-08-12T15:52:55+02:00"
      },
      {
        "desc" => "LATER_ONE",
        "timestamp" => "2019-08-12T15:52:55+02:00"
      }
    ]
  end

end
