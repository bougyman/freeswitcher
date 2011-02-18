require "fsr/app"
module FSR
  module Cmd
    class SchedTransfer < Command
      DEFAULTS = {when: 1, context: "default", dialplan: 'xml'}
      def initialize(fs_socket = nil, args = {})
        @fs_socket = fs_socket # FSR::CommandSocket obj
        args = DEFAULTS.merge(args)
        @when, @uuid, @to, @context, @dialplan = args.values_at(:when, :uuid, :to, :context, :dialplan)
        raise(ArgumentError, "No uuid given") unless @uuid
        raise(ArgumentError, "No to: extension given") unless @to
      end

      # Send the command to the event socket, using bgapi by default.
      def run(api_method = :api)
        orig_command = "%s %s" % [api_method, raw]
        Log.debug "saying #{orig_command}"
        @fs_socket.say(orig_command)
      end

      # This method builds the API command to send to the freeswitch event socket
      def raw
        "sched_transfer +#{@when} #{@uuid} #{@to} #{@dialplan} #{@context}"
      end
    end

    register(:sched_transfer, SchedTransfer)
  end
end
