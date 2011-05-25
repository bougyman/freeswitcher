require 'spec/helper'
require "fsr/cmd"
FSR::Cmd.load_command("valet_info")

describe "Testing FSR::Cmd::ValetInfo" do
  ## ValetInfo ##
  # Interface to valet_info
  it "FSR::Cmd::ValetInfo should send valet_info" do
    cmd = FSR::Cmd::ValetInfo.new
    cmd.raw.should == "valet_info"
  end

end
