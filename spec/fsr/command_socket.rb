require 'spec/helper'
require 'mocksocket'
require 'facon'
require 'fsr/command_socket'

class SampleCmd < FSR::Cmd::Command
  def initialize(*args)
    @args = args
  end

  def arguments
    @args
  end

  def self.cmd_name
    "sample_cmd"
  end

  def response=(data)
    @response = "From command: #{data.content}"
  end
end

module Facon
  class Expectation
    # Sets up the expected method to return the given value.
    # This has to be replaced with a proc, because lambda checks the number of arguments passed.
    def and_return(value)
      raise MockExpectationError, 'Ambiguous return expectation' unless @method_block.nil?

      @return_block = proc{ value }
    end
  end
end

describe FSR::CommandSocket do
  socket, server = MockSocket.pipe
  def socket.peeraddr
    [nil, 8021, nil, '127.0.0.1']
  end

  server.print "Content-Type: command/reply\nReply-Text: +OK\n\n"

  describe ":connect => false" do
    should "not connect" do
      @cmd = FSR::CommandSocket.new(:connect => false)
      server.should.be.empty
    end

    should "connect when asked" do
      @cmd.connect_with(socket)
      server.gets.should == "auth ClueCon\n"
    end
  end

  describe "connected CommandSocket" do
    socket, server = MockSocket.pipe
    def socket.peeraddr
      [nil, 8021, nil, '127.0.0.1']
    end

    server.print "Content-Type: command/reply\nReply-Text: +OK\n\n"
    cmd = FSR::CommandSocket.new(:connect => false)
    cmd.connect_with(socket)
    2.times{ server.gets }

    should "read header response" do
      server.print "Content-Type: command/reply\nSome-Header: Some value\n\n"
      reply = cmd.command "foo"

      reply.class.should == FSR::Response
      reply.headers[:some_header].should == "Some value"
      2.times{ server.gets }
    end

    should "read command/reply responses" do
      server.print "Content-Type: api/log\nSome-Header: Old data\n\n"
      server.print "Content-Type: command/reply\nSome-Header: New data\n\n"

      reply = cmd.command "foo"

      reply.headers[:some_header].should == "New data"
      2.times{ server.gets }
    end

    should "read api/response responses" do
      server.print "Content-Type: api/log\nSome-Header: Old data\n\n"
      server.print "Content-Type: api/response\nSome-Header: New data\n\n"

      reply = cmd.command "foo"

      reply.headers[:some_header].should == "New data"
      2.times{ server.gets }
    end

    should "read content if present" do
      server.print "Content-Type: command/reply\nContent-Length: 3\n\n+OK\n\n"
      reply = cmd.command "foo"

      reply.content.should == "+OK"
      2.times{ server.gets }
    end

    should "register command" do
      cmd.should.not.respond_to :sample_cmd
      FSR::CommandSocket.register_cmd SampleCmd
      cmd.should.respond_to :sample_cmd
    end

    describe "with commands" do
      FSR::CommandSocket.register_cmd SampleCmd

      should "send command" do
        server.print "Content-Type: command/reply\nContent-Length: 3\n\n+OK\n\n"
        cmd.sample_cmd
        server.gets.should == "bgapi sample_cmd\n"
        server.gets.should == "\n"
      end

      should "return response from command" do
        server.print "Content-Type: command/reply\nContent-Length: 3\n\n+OK\n\n"
        cmd.sample_cmd.content.should == "+OK"
        server.gets.should == "bgapi sample_cmd\n"
      end

      should "pass arguments" do
        server.print "Content-Type: command/reply\nContent-Length: 3\n\n+OK\n\n"
        cmd.sample_cmd("foo", "bar")
        server.gets.should == "\n"
        server.gets.should == "bgapi sample_cmd foo bar\n"
      end
    end

    describe "#run" do
      sample = SampleCmd.new

      should "send command" do
        server.print "Content-Type: command/reply\nContent-Length: 3\n\n+OK\n\n"
        cmd.run sample
        server.gets.should == "\n"
        server.gets.should == "bgapi sample_cmd\n"
      end

      should "return response from command" do
        server.print "Content-Type: command/reply\nContent-Length: 3\n\n+OK\n\n"
        cmd.run(sample).content.should == "+OK"
      end
    end
  end

  describe "automatic connect" do

    socket, server = MockSocket.pipe
    def socket.peeraddr
      [nil, 8021, nil, '127.0.0.1']
    end

    TCPSocket.should.receive(:open).and_return(socket)
    # Person.should.receive(:find).with(:all).and_return([@konata, @kagami])

    should 'authenticate' do
      server.print "Content-Type: command/reply\nReply-Text: +OK\n\n"
      cmd = FSR::CommandSocket.new
      server.gets.should == "auth ClueCon\n"
    end
  end
end
