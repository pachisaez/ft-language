require 'colorize'

module Token
	class Tag < Token::Base

		def initialize tag
			super Token::Base::TAG, tag
		end

		def value
			@lexeme[1..-1]
		end

		def printed
			@lexeme.colorize :green
		end

		def process
			puts "tag #{value}".colorize :green
		end

	end
end