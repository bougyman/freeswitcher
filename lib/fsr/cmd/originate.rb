require "fsr/app"
module FSR
  module Cmd
    class Originate < Command
      attr_accessor :target, :endpoint

      def initialize(args = {})
        # Right now, the spec expects DEFAULT_OPTIONS to be ignored, if we
        # change that, use the line below.
        # given_options = DEFAULT_OPTIONS.merge(args.to_hash)
        given_options = if TRAITS[FSR::Cmd::Originate]
                          TRAITS[FSR::Cmd::Originate].merge(args.to_hash)
                        else
                          args.to_hash
                        end

        @target_options = {}
        @endpoint = @target = nil

        given_options.each do |key, value|
          case key
          when :caller_id_number, :origination_caller_id_number
            @target_options[:origination_caller_id_number] = value
          when :caller_id_name, :origination_caller_id_name
            @target_options[:origination_caller_id_name] = value
          when :timeout, :originate_timeout
            @target_options[:originate_timeout] = timeout = value.to_int

            unless timeout > 0
              raise ArgumentError, "Given :timeout must be positive integer"
            end
          when :target
            @target = value.to_str

            if @target.empty?
              raise ArgumentError, "Cannot originate without given :target"
            end
          when :application
            next if @endpoint

            if @endpoint.kind_of?(FSR::App::Application)
              @endpoint = value
            else
              raise ArgumentError, "Given :endpoint is no FSR::App::Application"
            end
          when :endpoint
            @endpoint = value.to_str

            if @endpoint.empty?
              raise ArgumentError, "Cannot originate without given :endpoint"
            end
          else
            @target_options[key] = value
          end
        end
      end

      # This method builds the API command to send to the freeswitch event socket
      def raw
        target_opts = @target_options.
          sort_by{|key, value| key.to_s }.
          map{|key, value| "#{key}=#{value}" if key && value }.
          compact

        target =
          if target_opts.empty?
            "#{@target}"
          else
            "{#{target_opts.join(',')}}#{@target}"
          end

        if @endpoint.kind_of?(String)
          "bgapi originate #{target} #{@endpoint}"
        elsif @endpoint.kind_of?(FSR::App::Application)
          "bgapi originate #{target} '&#{@endpoint.raw}'"
        else
          raise "Invalid endpoint"
        end
      end

    end

    register Originate
  end
end
