require 'spec/helper'
require "fsr/cmd"
FSR::Cmd.load_command("conference")

describe "Testing FSR::Cmd::Conference" do
  it "Cannot use conference without :conference_name" do
    lambda { FSR::Cmd::Conference.new(nil) }.should.raise(ArgumentError).
      message.should.match(/Cannot use conference without :conference_name/)
  end

  it "Cannot dial without :target" do
    lambda { FSR::Cmd::Conference.new(nil, :conference_name => 1001, :action => :dial) }.should.raise(ArgumentError).
      message.should.match(/Cannot dial without :target/)
  end

  it "Cannot send dtmf without :target" do
    lambda { FSR::Cmd::Conference.new(nil, :conference_name => 1001, :action => :dtmf) }.should.raise(ArgumentError).
      message.should.match(/Cannot send dtmf without :target/)
  end

  it "Cannot send dtmf without :digits" do
    lambda { FSR::Cmd::Conference.new(nil, :conference_name => 1001, :action => :dtmf, :target => 1) }.should.raise(ArgumentError).
      message.should.match(/Cannot send dtmf without :digits/)
  end

  it "Cannot send kick without :target" do
    lambda { FSR::Cmd::Conference.new(nil, :conference_name => 1001, :action => :kick) }.should.raise(ArgumentError).
      message.should.match(/Cannot kick without :target/)
  end

  it "Should require target_options to be a hash" do
    lambda { FSR::Cmd::Conference.new(nil, :conference_name => 1001, :action => :dial, :target => "user/1000", :target_options => 1) }.should.raise(ArgumentError).
      message.should.match(/:target_options must be a hash/)
  end

  it "Dials and puts callee into conference" do
    conference = FSR::Cmd::Conference.new(nil, :conference_name => 1001, :action => :dial, :target => "user/1000")
    conference.raw.should == "conference 1001 dial user/1000"
  end

  it "Dials with :target_option" do
    conference = FSR::Cmd::Conference.new(nil, :conference_name => 1001, :action => :dial, :target => "user/1000", :target_options => {:ignore_early_media => true})
    conference.raw.should == "conference 1001 dial {ignore_early_media=true}user/1000"
  end

  it "Kicks member out of conference" do
    conference = FSR::Cmd::Conference.new(nil, :conference_name => "1001", :action => :kick, :target => 1)
    conference.raw.should == "conference 1001 kick 1"
  end

  it "Sends dtmf digits to a member" do
    conference = FSR::Cmd::Conference.new(nil, :conference_name => "1001", :action => :dtmf, :target => 1, :digits => 134)
    conference.raw.should == "conference 1001 dtmf 1 134"
  end

  it "Sends dtmf digits to all members" do
    conference = FSR::Cmd::Conference.new(nil, :conference_name => "1001", :action => :dtmf, :target => "all", :digits => 134)
    conference.raw.should == "conference 1001 dtmf all 134"
  end

  it "Sends dtmf digits to last member" do
    conference = FSR::Cmd::Conference.new(nil, :conference_name => "1001", :action => :dtmf, :target => "last", :digits => 134)
    conference.raw.should == "conference 1001 dtmf last 134"
  end
end
