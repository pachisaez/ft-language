require 'colorize'

module Token
	class Url < Token::Base

		def initialize url
			super Token::Base::URL, url
		end

		def printed
			@lexeme.colorize :light_blue
		end

	end
end