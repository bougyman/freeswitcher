require 'spec/helper'
require "fsr/cmd"
FSR::Cmd.load_command("channels")

describe "Testing FSR::Cmd::Channels" do
  ## Channels ##
  # Interface to channels
  it "FSR::Cmd::Channels should send show channels" do
    sofia = FSR::Cmd::Channels.new
    sofia.raw.should == "show channels"
  end

  it "FSR::Cmd::Channels should send show channels" do
    sofia = FSR::Cmd::Channels.new(true)
    sofia.raw.should == "show distinct_channels"
  end

end
