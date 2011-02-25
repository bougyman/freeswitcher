require "fsr/cmd"
require "fsr/utils/dtmf"
module FSR
  module Cmd
    class UuidSendDtmf < Command
      def initialize(fs_socket = nil, args = {})
        @fs_socket = fs_socket # FSR::CommandSocket obj
        @uuid, dtmf = args.values_at(:uuid, :dtmf)
        raise(ArgumentError, "No uuid given") unless @uuid
        raise(ArgumentError, "No dtmf data given") unless dtmf
        @dtmf = FSR::Utils::DTMF.from_string(dtmf)
      end

      # Send the command to the event socket, using bgapi by default.
      def run(api_method = :api)
        orig_command = "%s %s" % [api_method, raw]
        Log.debug "saying #{orig_command}"
        @fs_socket.say(orig_command)
      end

      # This method builds the API command to send to the freeswitch event socket
      def raw
        "uuid_send_dtmf #{@uuid} #{@dtmf}"
      end
    end

    register(:uuid_send_dtmf, UuidSendDtmf)
  end
end
