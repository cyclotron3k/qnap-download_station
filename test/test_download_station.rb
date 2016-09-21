require 'minitest/autorun'
require 'qnap/download_station'

class TestDownloadStation < Minitest::Test
	def test_argument
		assert_raises ArgumentError do
			Qnap::DownloadStation.new
		end
	end
end
