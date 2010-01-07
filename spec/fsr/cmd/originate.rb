require 'spec/helper'
require "fsr/cmd"

describe "Testing FSR::Cmd::Originate" do
  should "originate call to endpoint" do
    originate = FSR::Cmd::Originate.new(:target => 'user/bougyman', :endpoint => "4000")
    originate.raw.should == "bgapi originate user/bougyman 4000"
  end

  should "send specified variables" do
    originate = FSR::Cmd::Originate.new :target => 'user/bougyman', :endpoint => '1234',
                                        :ignore_early_media => true,
                                        :other_option => "value"

    originate.raw.should.match %r|^bgapi originate \{\S+\}user/bougyman 1234$|
    originate.raw.should.match /ignore_early_media=true/
    originate.raw.should.match /other_option=value/
  end
end
