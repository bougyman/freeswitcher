require "fsr/app"
module FSR
  module Cmd
    class SchedHangup < Command
      DEFAULTS = {when: 1, cause: "UNKNOWN"}
      def initialize(fs_socket = nil, args = {})
        @fs_socket = fs_socket # FSR::CommandSocket obj
        args = DEFAULTS.merge(args)
        @when, @uuid, @cause = args.values_at(:when, :uuid, :cause)
        raise(ArgumentError, "No uuid given") unless @uuid
      end

      # Send the command to the event socket, using bgapi by default.
      def run(api_method = :api)
        orig_command = "%s %s" % [api_method, raw]
        Log.debug "saying #{orig_command}"
        @fs_socket.say(orig_command)
      end

      # This method builds the API command to send to the freeswitch event socket
      def raw
        orig_command = "sched_hangup +#{@when} #{@uuid} #{@cause.dump}"
      end
    end

    register(:sched_hangup, SchedHangup)
  end
end
