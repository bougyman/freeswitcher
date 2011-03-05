require 'spec/helper'
require "fsr/app"
FSR::App.load_application("valet_park")

describe "Testing FSR::App::ValetPark" do

  it "puts the call into valet lot" do
    valet = FSR::App::ValetPark.new("mylot", :stall_number => '5555')
    valet.sendmsg.should == "call-command: execute\nexecute-app-name: valet_park\nexecute-app-arg: mylot 5555\n\n"
  end

  it "asks which valet lot to take call from" do
    valet = FSR::App::ValetPark.new("mylot", :action => :ask, :range => 1..11, :timeout => 10000, :prompt => 'enter_ext_pound.wav')
    valet.sendmsg.should == "call-command: execute\nexecute-app-name: valet_park\nexecute-app-arg: mylot ask 1 11 10000 enter_ext_pound.wav\n\n"
  end

  it "autoselect parking stall" do
    valet = FSR::App::ValetPark.new("mylot", :action => :auto, :range => 8501..8599)
    valet.sendmsg.should == "call-command: execute\nexecute-app-name: valet_park\nexecute-app-arg: mylot auto in 8501 8599\n\n"
  end

end
