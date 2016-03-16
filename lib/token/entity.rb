require 'colorize'

module Token
	class Entity < Token::Base

		def initialize entity
			super Token::Base::ENTITY, entity
		end

		def printed
			value.colorize :magenta
		end

		def process
			puts "entity #{value}".colorize :magenta
		end

	end
end