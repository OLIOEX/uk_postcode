require_relative "./test_helper"
require "csv"
require "uk_postcode"

describe "Full set of postcodes" do
  CSV_PATH = File.expand_path("../data/postcodes.csv", __FILE__)

  COUNTRIES = {
    'E92000001' => :england,
    'N92000002' => :northern_ireland,
    'S92000003' => :scotland,
    'W92000004' => :wales,
    'L93000001' => :channel_islands,
    'M83000003' => :isle_of_man
  }

  it "should correctly parse and find the country of every extant postcode" do
    if File.exist?(CSV_PATH)
      CSV.foreach(CSV_PATH, headers: [:postcode, :country]) do |row|
        outcode = row[:postcode][0,4].strip
        incode  = row[:postcode][4,3].strip
        country = COUNTRIES.fetch(row[:country])

        postcode = UKPostcode.new(outcode + incode)

        postcode.must_be :valid?
        postcode.outcode.must_equal outcode
        postcode.incode.must_equal incode
        postcode.country.must_equal country
      end
    else
      skip "Skipping because #{CSV_PATH} does not exist"
    end
  end
end