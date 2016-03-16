module Token
	class NewLine < Token::Base

		def initialize 
			super Token::Base::NEW_LINE, "\n"
		end

		def printed
			value
		end

	end
end