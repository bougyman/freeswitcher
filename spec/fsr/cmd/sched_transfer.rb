require './spec/helper'
require "fsr/cmd"
FSR::Cmd.load_command("sched_transfer")

describe "Testing FSR::Cmd::SchedTransfer" do
  ## Scheduled Transfer ##
  it "FSR::Cmd::SchedTransfer should schedule a Transfer with defaults" do
    cmd = FSR::Cmd::SchedTransfer.new nil, uuid: 1234, to: "5555"
    cmd.raw.should == 'sched_transfer +1 1234 5555 xml default'
  end

  it "FSR::Cmd::SchedTransfer should schedule a hangup with user-supplied time " do
    cmd = FSR::Cmd::SchedTransfer.new nil, uuid: 1234, to: "5555", when: 60
    cmd.raw.should == 'sched_transfer +60 1234 5555 xml default'
  end

  it "FSR::Cmd::SchedHangup should schedule a hangup with user-supplied context" do
    cmd = FSR::Cmd::SchedTransfer.new nil, uuid: 1234, context: "my_context", to: "5555"
    cmd.raw.should == 'sched_transfer +1 1234 5555 xml my_context'
  end

  it "FSR::Cmd::SchedTransfer should raise when not given uuid or to: extension" do
    lambda { cmd = FSR::Cmd::SchedTransfer.new nil, to: '5555' }.should.raise ArgumentError
    lambda { cmd = FSR::Cmd::SchedTransfer.new nil, uuid: 1234 }.should.raise ArgumentError
  end
end
