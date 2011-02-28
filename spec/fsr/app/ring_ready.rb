require 'spec/helper'
require "fsr/app"
FSR::App.load_application("ring_ready")

describe "Testing FSR::App::RingReady" do

  it "sends ring_ready to incoming call" do
    ans = FSR::App::RingReady.new
    ans.sendmsg.should == "call-command: execute\nexecute-app-name: ring_ready\n\n"
  end

end
