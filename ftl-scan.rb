require './lib/scanner'

puts "FacileThings Language"

print "Input: "
input = $stdin.read
puts "Scanning input: #{input}"

puts
scanner = Scanner.new input
t = scanner.nextToken
while not t.last? do
	print t.printed
	t = scanner.nextToken
end

puts
scanner = Scanner.new input
t = scanner.nextToken
while not t.last? do
	puts t.to_s
	t = scanner.nextToken
end
puts t.to_s

=begin
r = []
100000.times do
	t0 = Time.now
	scanner = Scanner.new input
	t = scanner.nextToken
	while t.type!=Token::EOS do
		t = scanner.nextToken
	end
	t1 = Time.now
	r << (t1 - t0)*1000.0
end
puts r.inspect
puts r.inject{ |sum, el| sum + el }.to_f / r.size
=end