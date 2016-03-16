require 'colorize'

module Token
	class Exception < Token::Base

		def initialize exception
			super Token::Base::EXCEPTION, exception
		end

		def printed
			value.colorize :red
		end

	end
end