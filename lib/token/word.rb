require 'colorize'

module Token
	class Word < Token::Base

		def initialize word
			super Token::Base::WORD, word
		end

		def printed
			@lexeme.colorize :white
		end

	end
end