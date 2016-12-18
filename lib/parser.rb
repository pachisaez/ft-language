require 'colorize'

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
		if @lookahead.type==Token::Base::COMMAND
			case @lookahead.value
			when ":urgent"
				commandUrgent
			when ":energy"
				commandEnergy
			when ":time"
				commandTime
			else
				error "command error", "#{@lookahead.value} "
			end
		else
			@lookahead.process
		end
	end

	def consumeSpaces
		consume while isNothing?
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
		consumeSpaces
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

	def isNothing?
		[Token::Base::SPACE, Token::Base::NEW_LINE].include? @lookahead.type
	end

	def nextTokenIs(regex)
		consume
		consumeSpaces
		@lookahead.value =~ regex
	end

	def error(message, output)
		puts message.colorize(:red)
		@output << output.colorize(:red)
	end

	def commandUrgent
		puts "urgent"
	end

	def commandEnergy
		if nextTokenIs(/low/i)
			puts "energy low"
		else
			error "energy error", ":energy #{@lookahead.value} "
		end
	end

	def commandTime
		if nextTokenIs(/[0-9]+/i)
			@param1 = @lookahead
			if nextTokenIs(/minute(s)?|min|m|hr(s)?|hour(s)?|h/i)
	      time = @param1.value.to_i
      	time *= 60 if @lookahead.value.include?("h")
				puts "time #{time} minutes"
			else
				error "time error", ":time #{@param1.value} #{@lookahead.value} "
			end
		else
			error "time error", ":time #{@lookahead.value} "
		end
	end

end