class Parser
	attr_reader :tokens, :output

	def initialize scanner
		@tokens = scanner.tokens
		@position = 0
		@lookahead = @tokens[@position]
		@output = ""
	end

	def parse
		while not @lookahead.last?
			expr
		end
	end

	def expr
		if isPrintable?
			display
		elsif isExecutable?
			execute
		elsif isBoth?
			execAndDisplay
		else
			consume
		end
	end

private
	def print
		@output << @lookahead.printed 
	end

	def process
		@lookahead.process
	end

	def match(type)
		if @lookahead.type==type
			consume
		end
	end
	
	def consume
		@position += 1
		@lookahead = @tokens[@position]
	end

	def display
		print
		consume
	end

	def execute
		process
		consume
		while @lookahead.type==Token::Base::SPACE
			consume
		end
	end

	def execAndDisplay
		process
		print
		consume 
	end

	def isPrintable?
		[Token::Base::CHUNK, Token::Base::SPACE, Token::Base::NEW_LINE, 
		 Token::Base::EXCEPTION, Token::Base::EMAIL, Token::Base::URL].include? @lookahead.type
	end

	def isExecutable?
		[Token::Base::COMMAND, Token::Base::FOCUS].include? @lookahead.type
	end

	def isBoth?
		[Token::Base::TAG, Token::Base::ENTITY].include? @lookahead.type
	end
end