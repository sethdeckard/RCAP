require 'spec_helper'

describe(RCAP::CAP_1_2::Geocode) do
  before(:each) do
    @geocode_builder = lambda do |geocode|
      geocode.name = 'name'
      geocode.value = 'value'
    end
  end

  context('when initialised') do
    context('from XML') do
      before(:each) do
        @original_geocode = RCAP::CAP_1_2::Geocode.new(&@geocode_builder)
        @alert = RCAP::CAP_1_2::Alert.new
        @alert.add_info.add_area.add_geocode(&@geocode_builder)
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new(@xml_string)
        @info_xml_element = RCAP.xpath_first(@xml_document.root, RCAP::CAP_1_2::Info::XPATH, RCAP::CAP_1_2::Alert::XMLNS)
        @area_xml_element = RCAP.xpath_first(@info_xml_element, RCAP::CAP_1_2::Area::XPATH, RCAP::CAP_1_2::Alert::XMLNS)
        @geocode_xml_element = RCAP.xpath_first(@area_xml_element, RCAP::CAP_1_2::Geocode::XPATH, RCAP::CAP_1_2::Alert::XMLNS)
        @geocode = RCAP::CAP_1_2::Geocode.from_xml_element(@geocode_xml_element)
      end

      it('should parse into the correct class') do
        @geocode.class.should == RCAP::CAP_1_2::Geocode
      end

      it('should parse the name correctly') do
        @geocode.name.should == @original_geocode.name
      end

      it('should parse the value correctly') do
        @geocode.value.should == @original_geocode.value
      end
    end
  end

  context('when exported') do
    before(:each) do
      @geocode = RCAP::CAP_1_2::Geocode.new(&@geocode_builder)
    end

    context('to a hash') do
      it('should export correctly') do
        @geocode.to_h.should == { 'name' => 'value' }
      end
    end
  end
end
