require './spec/helper'
require "fsr/cmd"
FSR::Cmd.load_command("uuid_transfer")

describe "Testing FSR::Cmd::UuidTransfer" do
  ## UUID Transfer ##
  #uuid_transfer <uuid> [-bleg|-both] <dest-exten> [<dialplan>] [<context>]
  it "FSR::Cmd::UuidTransfer should Transfer with defaults" do
    cmd = FSR::Cmd::UuidTransfer.new nil, uuid: 1234, to: "5555"
    cmd.raw.should == 'uuid_transfer 1234 -bleg 5555 xml default'
  end

  it "FSR::Cmd::UuidTransfer should transfer with user-supplied context" do
    cmd = FSR::Cmd::UuidTransfer.new nil, uuid: 1234, context: "my_context", to: "5555"
    cmd.raw.should == 'uuid_transfer 1234 -bleg 5555 xml my_context'
  end

  it "FSR::Cmd::UuidTransfer should transfer both legs" do
    cmd = FSR::Cmd::UuidTransfer.new nil, uuid: 1234, both: true, to: "5555"
    cmd.raw.should == 'uuid_transfer 1234 -both 5555 xml default'
  end

  it "FSR::Cmd::UuidTransfer should raise when not given uuid or to: extension" do
    lambda { cmd = FSR::Cmd::UuidTransfer.new nil, to: '5555' }.should.raise ArgumentError
    lambda { cmd = FSR::Cmd::UuidTransfer.new nil, uuid: 1234 }.should.raise ArgumentError
  end
end
