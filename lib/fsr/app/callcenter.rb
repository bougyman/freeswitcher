require "fsr/app"
module FSR
  module App
    class Callcenter < Application
      attr_reader :queue
      def initialize(queue)
        @queue = queue
      end

      def arguments
        [queue]
      end

      def sendmsg
        "call-command: execute\nexecute-app-name: %s\nexecute-app-arg: %s\nevent-lock:true\n\n" % [app_name, arguments.join(" ")]
      end
    end

    register(:callcenter, Callcenter)
  end
end
