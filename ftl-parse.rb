require './lib/parser'
require './lib/scanner'

puts "FacileThings DSL"

print "Input: "
input = $stdin.read
puts "Input:".colorize :red
puts input

puts
puts "Parse:".colorize :red
scanner = Scanner.new input
parser = Parser.new scanner
parser.parse

puts
puts "Output: ".colorize :red
puts parser.output