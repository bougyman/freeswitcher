require 'ostruct'

module FSR
  module Model
    class Channel < OpenStruct
      attr_reader :fields

      def initialize(fields, *data)
        @fields = fields
        super(Hash[@fields.zip(data)])
      end
    end
  end
end
