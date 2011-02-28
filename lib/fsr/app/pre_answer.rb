
require "fsr/app"
module FSR
  module App
    class PreAnswer < Application
      # PreAnswer a call
     
      def initialize
      end

      def arguments
        []
      end

      def sendmsg
        "call-command: execute\nexecute-app-name: %s\n\n" % [app_name]
      end

      def app_name
        'pre_answer'
      end

    end

    register(:pre_answer, PreAnswer)
  end
end
