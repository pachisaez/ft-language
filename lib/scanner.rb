require 'strscan'
require_relative 'token'

class Scanner
	attr_reader :input

	SPACE 				= /[ \t]+/
	NEW_LINE 			= /[\n\r]+/

	CHARACTER			= /[[:alnum:]_\-]/
	WORD					= /[[:alnum:]_\-]+/
	EMAIL 				= /[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+/i
	URL 					= /https?:\/\/[a-z\d\-\.]+\.[a-z]+/i

	DIGIT 				= /[[:digit:]\-\+]/
	NUMBER 				= /[\-\+]?[[:digit:]]+(\.?[[:digit:]]+)?/

	TAG 					= /#[[:alnum:]_\-]+/
	ENTITY				= /@[[:alnum:]_\-]+/
	COMMAND 			= /:day|:start|:expected|:time|:energy|:urgent/i
	FOCUS 				= /!!/

	PUNCTUATION 	= /[[:punct:]]/

	def initialize input=''
		@input = StringScanner.new input
	end

	def nextToken
		while !@input.eos?
			lookahead = @input.peek(1)
			case lookahead
				when SPACE
			    return space
			  when NEW_LINE
			  	return newLine
			  when DIGIT
			  	return number
			  when CHARACTER
			  	return word
			  when "#"
			  	return tag
			  when "@"
			  	return entity
			  when ":"
			  	return command
			  when "!"
			  	return focus
			  when PUNCTUATION
			  	return punctuation
				else
					return exception
			end
		end
		return eos
	end

	def tokens
		@input.reset		
		tokens = []
		begin
			t = nextToken
			tokens << t
		end until t.last?
		tokens
	end

private
	def eos
		Token::Eos.new
	end

	def space
		@input.scan SPACE
		Token::Space.new
	end

	def newLine
		@input.scan NEW_LINE 
		Token::NewLine.new
	end

	def exception
		Token::Exception.new @input.getch
	end

	def word
		if @input.check URL
			Token::Url.new @input.scan URL
		elsif @input.check EMAIL
			Token::Email.new @input.scan EMAIL
		else
			Token::Word.new @input.scan WORD
		end
	end

	def number
		Token::Number.new @input.scan NUMBER
	end

	def punctuation
		Token::Punctuation.new @input.getch
	end

	def tag
		if @input.check TAG
			Token::Tag.new @input.scan TAG
		else
			punctuation
		end
	end

	def entity
		if @input.check ENTITY
			Token::Entity.new @input.scan ENTITY
		else
			punctuation
		end
	end

	def command
		if @input.check COMMAND
			Token::Command.new @input.scan COMMAND
		else
			punctuation
		end
	end

	def focus
		if @input.check FOCUS
			@input.scan FOCUS
			Token::Focus.new 
		else
			punctuation
		end
	end
end