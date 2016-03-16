module Token
	class Focus < Token::Base

		def initialize
			super Token::Base::FOCUS, nil
		end

		def process
			puts "focused".colorize :cyan
		end

	end
end