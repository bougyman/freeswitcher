module FSR
  module Model
    class Agent
      attr_reader :fields, :extension, :full_name

      def initialize(headers, *data)
        @fields = headers
        @fields.each_with_index do |h,i|
          (class << self; self; end).send(:define_method,h.to_sym) { data[i] }
        end

        @extension, @full_name = name.split("_", 2)
      end
    end
  end
end
