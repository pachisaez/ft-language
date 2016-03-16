require 'colorize'

module Token
	class Chunk < Token::Base

		def initialize chunk
			super Token::Base::CHUNK, chunk
		end

		def printed
			value.colorize :white
		end

	end
end