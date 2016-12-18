require 'colorize'

module Token
	class Command < Token::Base

		def initialize command
			super Token::Base::COMMAND, command
		end

		def printed
			@lexeme.colorize :cyan
		end

		def process
			puts "#{value}"
		end

	end
end