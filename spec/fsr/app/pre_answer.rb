require 'spec/helper'
require "fsr/app"
FSR::App.load_application("pre_answer")

describe "Testing FSR::App::PreAnswer" do

  it "pre_answers the incoming call" do
    ans = FSR::App::PreAnswer.new
    ans.sendmsg.should == "call-command: execute\nexecute-app-name: pre_answer\n\n"
  end

end
