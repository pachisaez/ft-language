module Token
	class Eos < Token::Base

		def initialize
			super Token::Base::EOS, nil
		end

	end
end