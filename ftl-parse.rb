require './lib/parser'
require './lib/grammar'

puts "FacileThings DSL"

print "Input: "
input = $stdin.read
puts "Input:".colorize :red
puts input

puts
puts "Parse:".colorize :red
scanner = Grammar.new input
parser = Parser.new scanner
parser.parse

puts
puts "Output: ".colorize :red
puts parser.output