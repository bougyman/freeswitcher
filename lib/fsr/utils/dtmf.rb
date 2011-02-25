module FSR
  module Utils
    module DTMF
      MAP = Hash[ 
        [%w{a b c},
         %w{d e f},
         %w{g h i},
         %w{j k l},
         %w{m n o},
         %w{p q r s},
         %w{t u v},
         %w{w x y z}
        ].zip((2 .. 9).to_a)
      ]

      def self.from_string(dtmf)
        dtmf.each_char.map { |char|
          if digit = MAP[MAP.keys.detect { |k| k.include? char }]
            digit
          else
            char
          end
        }.join
      end
    end
  end
end
