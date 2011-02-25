require "spec/helper"
describe "FSR::Utils::DTMF module" do
  it "Converts letters to numbers" do
    require "fsr/utils/dtmf"
    FSR::Utils::DTMF.from_string("afr").should.equal '237'
  end

  it "Doesn't Affect numbers" do
    require "fsr/utils/dtmf"
    FSR::Utils::DTMF.from_string("1234567890").should.equal '1234567890'
  end

  it "Allows mixed number/letter" do
    require "fsr/utils/dtmf"
    FSR::Utils::DTMF.from_string("1a2d3g4k5n6s7u8z90").should.equal '122334455667788990'
  end
end

