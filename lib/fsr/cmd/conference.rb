require "fsr/cmd"
module FSR
  module Cmd
    class Conference < Command
      attr_reader :fs_socket, :conference_name, :profile, :pin, :flags, :action, :target, :target_options, :digits
      def initialize(fs_socket = nil, args = {})
        raise(ArgumentError, "args (Passed: <<<#{args}>>>) must be a hash") unless args.kind_of?(Hash)
        @conference_name, @pin, @profile, @flags = args.values_at(:conference_name, :pin, :profile, :flags)
        @action, @target, @target_options = args.values_at(:action, :target, :target_options)
        @digits = args[:digits]
        @fs_socket = fs_socket
        raise(ArgumentError, "Cannot use conference without :conference_name") unless @conference_name
        case @action
          when :dial
            raise(ArgumentError, "Cannot dial without :target") unless @target
            if @target_options
              raise(ArgumentError, ":target_options must be a hash if :target_options is set") unless @orginate_options.kind_of?(Hash)
            end
          when :dtmf
            raise(ArgumentError, "Cannot send dtmf without :target") unless @target
            raise(ArgumentError, "Cannot send dtmf without :digits") unless @digits
          when :kick
            raise(ArgumentError, "Cannot kick without :target") unless @target
          else
            # go with flow, mate
        end
      end

      # Send the command to the event socket, using bgapi by default.
      def run(api_method = :bgapi)
        conf_command = "%s %s" % [api_method, raw]
        Log.debug "saying #{conf_command}"
        @fs_socket.say(conf_command)
      end

      def arguments
        target_options = target_options.keys.sort { |a,b| a.to_s <=> b.to_s }.map { |k| "%s=%s" % [k, orginate_options[k]] }.join(",") if target_options
        conference_name << "@#{profile}" if profile
        if pin
          conference_name << "+#{pin}"
          conference_name << "+#{flags}" if flags
        end
        args = [conference_name]
        args << action if action

        if target
          @target = "{#{target_options}}#{target}" if target_options
          args << target
        end

        args << digits if action == :dtmf
        args.compact
      end

      def raw
        ["conference", *arguments].join(" ")
      end

    end

    register(:conference, Conference)
  end
end
