require 'ostruct'
module FSR
  module Model
    class Agent < OpenStruct
      attr_accessor :extension, :full_name

      def initialize(fields, *data)
        super(Hash[fields.zip(data)])
        @extension, @full_name = name.split("-", 2)
      end

      def fields
        raise NotImplementedError, "This class is now an OpenStruct"
      end

    end
  end
end
