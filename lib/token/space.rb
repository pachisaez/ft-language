module Token
	class Space < Token::Base

		def initialize 
			super Token::Base::SPACE, " "
		end

		def printed
			@lexeme
		end

	end
end