require 'colorize'

module Token
	class Exception < Token::Base

		def initialize exception
			super Token::Base::EXCEPTION, exception
		end

		def printed
			@lexeme.colorize :light_red
		end

	end
end