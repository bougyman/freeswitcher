require 'fsr/command_socket'
require 'fsr/listener/base'
require 'fsr/response'
require 'fsr/traited'

module FSR
  module Cmd
    COMMANDS = []

    def self.register(cmd)
      COMMANDS << cmd
      FSR::CommandSocket.register_cmd(cmd)
      FSR::Listener::Base.register_cmd(cmd)
    end

    class Command
      include ::FSR::Traited
      attr_reader :response
      attr_accessor :background

      DEFAULT_OPTIONS = {
        :origination_caller_id_name => FSR::DEFAULT_CALLER_ID_NAME,
        :origination_caller_id_number => FSR::DEFAULT_CALLER_ID_NUMBER,
        :originate_timeout => 30,
        :ignore_early_media => true
      }

      protected

      def default_options(args = {}, defaults = nil, &block)
        opts = if defaults.nil?
          DEFAULT_OPTIONS.merge(args)
        else
          raise(ArgumentError, "defaults argument must ba a hash") unless defaults.kind_of?(Hash)
          defaults.merge(args)
        end
        yield opts if block_given?
      end

      public

      def self.cmd_name
        name.split("::").last.downcase
      end

      def cmd_name
        self.class.cmd_name
      end

      def background
        @background.nil? ? true : @background
      end

      def arguments
        []
      end

      def response=(r)
        @response = r
      end

      # I don't like the look of this method. ~harry
      def raw
        if background
          ['bgapi', cmd_name, *arguments].join(' ')
        else
          ['api', cmd_name, *arguments].join(' ')
        end
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), "cmd", "*.rb")].each do |cmd|
  require cmd
end

FSC = FSR::Cmd
