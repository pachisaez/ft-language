require 'colorize'

module Token
	class Command < Token::Base

		def initialize command
			super Token::Base::COMMAND, command
		end

		def printed
			value.colorize :light_blue
		end

		def process
			puts "command #{value}".colorize :light_blue
		end

	end
end