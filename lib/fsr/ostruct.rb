require "ostruct"
require "json"
module FSR
  class OpenStruct < ::OpenStruct
    def to_json(*args)
      @table.to_json *args
    end

    def to_hash
      @table.dup
    end
  end
end
