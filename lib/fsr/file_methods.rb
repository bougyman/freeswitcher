module FSR
  module App
    module FileMethods
      def test_files *files
        files.each do |file|

          if file =~ /^\//
            raise Errno::ENOENT unless File.exists? file
          end
        end
        true
      end
    end

  end
end
