module FSR
  module Model
    class Call
      attr_reader :created, :created_epoch, :function, :caller_id_name, :caller_id_number,
                  :caller_destination, :caller_channel_name, :caller_uuid, :callee_id_name,
                  :callee_id_number, :callee_destination, :callee_channel_name, :callee_uuid, :hostname
      def initialize(headers, *data)
        headers.each_with_index do |h,i| 
          instance_variable_set "@#{h}", data[i] 
        end
      end
    end
  end
end
