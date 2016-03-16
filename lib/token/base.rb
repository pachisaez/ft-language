require 'colorize'

module Token
	class Base
		include Comparable

		attr_accessor :type, :value

		ERROR = -3
		EXCEPTION = -2
		EOS = -1
		CHUNK = 0
		SPACE = 1
		NEW_LINE = 2
		TAG = 3
		ENTITY = 4
		COMMAND = 5
		EMAIL = 6
		URL = 7
		FOCUS = 8

		TOKEN_NAMES = [ 'ERROR', 'EXCEPTION', 'EOS', 'CHUNK', 'SPACE', 'NEW_LINE', 'TAG', 
			'ENTITY', 'COMMAND', 'EMAIL', 'URL', 'FOCUS']

		def initialize type, value
			@type, @value = type, value
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
			"[#{TOKEN_NAMES[@type+3]}: #{@value}]"
		end

		def printed
		end

		def process
		end

	end
end