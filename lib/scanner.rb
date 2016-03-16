require_relative 'token'

class Scanner
	attr_reader :input

	EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	URL = /https?:\/\/[\S]+/

	def initialize input=''
		@input = StringIO.new input
		consume
	end

	def nextToken
		if isNil?
			eos
		elsif isSpace?
			space
		elsif isNewLine?
			newLine
		elsif isTag?
			tag
		elsif isEntity?
			entity
		elsif isCommand?
			command
		elsif isWord?
			chunk
		elsif isFocus?
			focus
		else
			exception
		end
	end

	def tokens
		@input.seek 0
		consume
		
		tokens = []
		begin
			t = nextToken
			tokens << t
		end until t.last?
		tokens
	end

private
	def consume
		@char = @input.getc
	end
	
	def eos
		Token::Eos.new
	end

	def space
		consume while isSpace?
		Token::Space.new
	end

	def newLine
		consume while isNewLine?
		Token::NewLine.new
	end

	def tag
		buffer = StringIO.new
		begin
			buffer << @char
			consume
		end while isWord?
		Token::Tag.new buffer.string.downcase
	end

	def entity
		buffer = StringIO.new
		begin
			buffer << @char
			consume
		end while isWord?
		Token::Entity.new buffer.string.downcase
	end

	def command
		buffer = StringIO.new
		begin
			buffer << @char
			consume
		end while isWord?
		Token::Command.new buffer.string.downcase
	end

	def chunk
		email_state = 0
		buffer = StringIO.new
		begin
			buffer << @char
			last_char = @char
			consume
		end while isChunk? # read until space
		if last_char !~ /[[:word:]\-]/ then # then backtrack to last /w character
			@input.ungetc(@char)
			while last_char !~ /[[:word:]\-]/ do 
				@input.ungetc(last_char)
				buffer.ungetc(last_char)
				buffer.seek(buffer.tell - 1)
				last_char = buffer.getc
			end
			consume
		end
		value = buffer.string[0..buffer.tell-1]
		if value =~ EMAIL then 
			Token::Email.new value
		elsif value =~ URL then
			Token::Url.new value
		else
			Token::Chunk.new value
		end
	end

	def focus
		char = @char
		consume
		if @char=="!"
			consume
			Token::Focus.new
		else
			Token::Exception.new "!"
		end
	end

	def exception
		char = @char
		consume
		Token::Exception.new char
	end

	def isNil?
		@char.nil?
	end

	def isSpace?
		@char =~ /[ \t]/
	end

	def isNewLine?
		@char =~ /[\n\r]/
	end

	def isTag?
		@char == "#"
	end 

	def isEntity?
		@char == "@"
	end 

	def isCommand?
		@char == ":"
	end

	def isFocus?
		@char == "!"
	end

	def isChunk?
		@char =~ /\S/
	end

	def isWord?
		@char =~ /[[:word:]\-]/
	end
end