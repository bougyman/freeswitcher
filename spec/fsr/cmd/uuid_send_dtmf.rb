require './spec/helper'
require "fsr/cmd"
FSR::Cmd.load_command("uuid_send_dtmf")

describe "Testing FSR::Cmd::UuidSendDtmf" do
  ## UUID Send DTMF Tones ##
  #uuid_send_dtmf <uuid> <uuid_data>
  it "FSR::Cmd::UuidSendData should Send DTMF with digits" do
    cmd = FSR::Cmd::UuidSendDtmf.new nil, uuid: 1234, dtmf: "5555"
    cmd.raw.should == 'uuid_send_dtmf 1234 5555'
  end

  it "FSR::Cmd::UuidSendData should Send DTMF with letters" do
    cmd = FSR::Cmd::UuidSendDtmf.new nil, uuid: 1234, dtmf: "aceventura"
    cmd.raw.should == 'uuid_send_dtmf 1234 2238368872'
  end

  it "FSR::Cmd::UuidSendData should raise an argument error without uuid or dtmf" do
    lambda { FSR::Cmd::UuidSendDtmf.new nil, uuid: 1234 }.should.raise ArgumentError
    lambda { FSR::Cmd::UuidSendDtmf.new nil, dtmf: 1234 }.should.raise ArgumentError
  end
end
