require './spec/helper'
require "fsr/cmd"
FSR::Cmd.load_command("sched_hangup")

describe "Testing FSR::Cmd::Callcenter" do
  ## Scheduled Hangup ##
  it "FSR::Cmd::SchedHangup should schedule a hangup with default " do
    cmd = FSR::Cmd::SchedHangup.new nil, uuid: 1234
    cmd.raw.should == 'sched_hangup +1 1234 "UNKNOWN"'
  end

  it "FSR::Cmd::SchedHangup should schedule a hangup with user-supplied time " do
    cmd = FSR::Cmd::SchedHangup.new nil, uuid: 1234, when: 60
    cmd.raw.should == 'sched_hangup +60 1234 "UNKNOWN"'
  end

  it "FSR::Cmd::SchedHangup should schedule a hangup with user-supplied cause " do
    cmd = FSR::Cmd::SchedHangup.new nil, uuid: 1234, cause: "No Reason"
    cmd.raw.should == 'sched_hangup +1 1234 "No Reason"'
  end

  it "FSR::Cmd::SchedHangup should schedule a hangup with user-supplied cause " do
    cmd = FSR::Cmd::SchedHangup.new nil, uuid: 1234, cause: "No Reason"
    cmd.raw.should == 'sched_hangup +1 1234 "No Reason"'
  end

  it "FSR::Cmd::SchedHangup should schedule a hangup with user-supplied cause containing quote" do
    cmd = FSR::Cmd::SchedHangup.new nil, uuid: 1234, cause: 'Say "WHAT?"'
    cmd.raw.should == 'sched_hangup +1 1234 "Say \"WHAT?\""'
  end
  
  it "FSR::Cmd::SchedHangup should raise " do
    lambda { cmd = FSR::Cmd::SchedHangup.new nil, cause: "No Reason" }.should.raise ArgumentError
  end
end
