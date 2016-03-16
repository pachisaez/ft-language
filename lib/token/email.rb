require 'colorize'

module Token
	class Email < Token::Base

		def initialize email
			super Token::Base::EMAIL, email
		end

		def printed
			value.colorize :yellow
		end

	end
end