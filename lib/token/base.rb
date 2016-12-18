require 'colorize'

module Token
	class Base
		include Comparable

		attr_accessor :type, :lexeme

		ERROR = -3
		EXCEPTION = -2
		EOS = -1
		WORD = 0
		NUMBER = 1
		PUNCTUATION = 2
		SPACE = 3
		NEW_LINE = 4

		CHUNK = 5
		TAG = 6
		ENTITY = 7
		COMMAND = 8
		EMAIL = 9
		URL = 10
		FOCUS = 11

		TOKEN_NAMES = [ 'ERROR', 'EXCEPTION', 'EOS', 'WORD', 'NUMBER', 'PUNCTUATION',
			'SPACE', 'NEW_LINE', 
			'CHUNK', 'TAG', 'ENTITY', 'COMMAND', 'EMAIL', 'URL', 'FOCUS']

		def initialize type, lexeme
			@type, @lexeme = type, lexeme
		end

		def value
			@lexeme.to_s
		end

		def <=> other
	    comparison = type <=> other.type
	    if comparison==0
	    	comparison = value <=> other.value
	    end
	    comparison
	  end

	  def last?
	  	type == EOS
	  end

		def to_s
			"[#{TOKEN_NAMES[@type+3]}: \"#{@lexeme}\" #{value}]"
		end

		def printed
		end

		def process
		end

	end
end