require 'colorize'

module Token
	class Punctuation < Token::Base

		def initialize punct
			super Token::Base::PUNCTUATION, punct
		end

		def printed
			@lexeme.colorize :red
		end

	end
end