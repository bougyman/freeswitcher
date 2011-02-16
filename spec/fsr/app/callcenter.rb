require 'spec/helper'
require "fsr/app"
FSR::App.load_application("callcenter")

describe "Testing FSR::App::Callcenter" do
  it "Sends the call to callcenter" do
    callcenter = FSR::App::Callcenter.new("support@default")
    callcenter.sendmsg.should == "call-command: execute\nexecute-app-name: callcenter\nexecute-app-arg: support@default\nevent-lock:true\n\n"
  end

end
