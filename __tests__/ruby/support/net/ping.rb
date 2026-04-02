module Net
  module Ping
    class External
      def initialize(*_args); end

      def ping
        true
      end
    end
  end
end
