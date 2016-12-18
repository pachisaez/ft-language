require 'colorize'

module Token
	class Email < Token::Base

		def initialize email
			super Token::Base::EMAIL, email
		end

		def printed
			@lexeme.colorize :light_blue
		end

	end
end