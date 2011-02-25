require_relative '../ostruct'
module FSR
  module Model
    class Queue < OpenStruct
      def initialize(fields, *data)
        super(Hash[fields.zip(data)])
      end

      def fields
        raise NotImplementedError, "This class is now an OpenStruct"
      end

    end
  end
end
