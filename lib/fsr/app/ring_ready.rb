
require "fsr/app"
module FSR
  module App
    class RingReady < Application
      # RingReady a call
     
      def initialize
      end

      def arguments
        []
      end

      def sendmsg
        "call-command: execute\nexecute-app-name: %s\n\n" % [app_name]
      end

      def app_name
        'ring_ready'
      end

    end

    register(:ring_ready, RingReady)
  end
end
