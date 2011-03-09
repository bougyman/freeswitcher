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

      # This method builds the API command to send to the freeswitch event socket
      def raw
        target_options = target_options.keys.sort { |a,b| a.to_s <=> b.to_s }.map { |k| "%s=%s" % [k, orginate_options[k]] }.join(",") if target_options

        conf_command = "conference #{conference_name}"
        conf_command = "#{conf_command}@#{profile}" if profile
        conf_command = "#{conf_command}+#{pin}" if pin
        conf_command = "#{conf_command}+#{flags}" if flags
        conf_command = "#{conf_command} #{action}" if action

        if target_options
          conf_command = "#{conf_command} {#{target_options}}#{target}" if target
        else
          conf_command = "#{conf_command} #{target}" if target
        end

        if action == :dtmf
          conf_command = "#{conf_command} #{digits}" if digits
        end

        conf_command
      end

    end

    register(:conference, Conference)
  end
end
