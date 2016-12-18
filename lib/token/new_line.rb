module Token
	class NewLine < Token::Base

		def initialize 
			super Token::Base::NEW_LINE, "\n"
		end

		def printed
			@lexeme
		end

	end
end