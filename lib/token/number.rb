require 'colorize'

module Token
	class Number < Token::Base

		def initialize number
			super Token::Base::NUMBER, number
		end

		def value
			@lexeme.to_f
		end

		def printed
			@lexeme.colorize :yellow
		end

	end
end