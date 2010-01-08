require 'socket'
require 'fsr/response'

module FSR
  class CommandSocket
    attr_reader :last_sent, :server, :port

    def self.register_cmd(klass)
      define_method klass.cmd_name do |*args|
        cmd = klass.new(*args)
        run(cmd)
      end
    end

    def initialize(args = {})
      @server   = (args[:server] || "127.0.0.1").to_str
      @port     = (args[:port] || 8021).to_int
      @auth     = (args[:auth] || "ClueCon").to_str

      connect unless args[:connect] == false
    end

    def connect
      connect_with(TCPSocket.open(@server, @port))
    end

    # Connect with given +socket+.
    # Ignores all settings given to [initialize].
    def connect_with(socket)
      @socket = socket
      _, @port, _, @server = socket.peeraddr
      command "auth #@auth"
    end

    def run(cmd)
      cmd.response = command(cmd.raw)
    end

    def command(msg)
      @socket.print(@last_sent = "#{msg}\n\n")
      read_response
    end

    def read_response
      response = FSR::Response.new

      until response.command_reply? || response.api_response?
        response.headers = read_headers
      end

      length = response.headers[:content_length].to_i
      response.content = @socket.read(length) if length > 0

      response
    end

    def read_headers
      headers = []

      while line = @socket.gets
        break if line == "\n"
        headers << line
      end

      headers.join
    end
  end
end

require 'fsr/cmd'
