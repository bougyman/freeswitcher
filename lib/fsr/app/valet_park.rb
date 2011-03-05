require "fsr/app"
module FSR
  module App
    class ValetPark < Application
      attr_reader :valet_lot, :stall_number, :action, :range, :timeout, :prompt

      def initialize(valet_lot, args = {})
        @valet_lot = valet_lot
        @stall_number, @action, @range, @timeout, @prompt = args.values_at(:stall_number, :action, :range, :timeout, :prompt)
        case action
          when nil
            raise "Usage: <valet_info> <stall_number>" unless @valet_lot && @stall_number
          when :ask
            raise "Usage: <valet_lot> <range> <timeout> <prompt>" unless @valet_lot && @range && @timeout && @prompt
            @range = "#{@range.min} #{@range.max}"          
          when :auto
            raise "Usage: <valet_lot> <range>" unless @valet_lot && @range
            @range = "#{@range.min} #{@range.max}" 
            @action = "auto in" 
          else
            raise "Action must be nil, ask or auto" 
        end
      end

      def arguments
        [valet_lot, stall_number, action, range, timeout, prompt].compact
      end

      def app_name
        'valet_park'
      end
    end

    register(:valet_park, ValetPark)
  end
end

