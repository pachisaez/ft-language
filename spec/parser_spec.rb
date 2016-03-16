require 'spec_helper'

describe Parser do
	describe '#initialize' do
		it "should get a list of tokens" do
			parser = Parser.new (Scanner.new "hello, world!")

			expect(parser.tokens[0]).to be_a Token::Base
			expect(parser.tokens.size).to eq 6
		end
	end

	describe "#expr" do
		it "should print the value if it's printable" do
			parser = Parser.new (Scanner.new "hello")
			parser.parse
			token = Token::Chunk.new "hello"
			expect(parser.output).to eq token.printed
		end
		it "should print and process the value if it's a tag" do
			parser = Parser.new (Scanner.new "#tag")
			expect(parser).to receive(:process)
			parser.parse
			token = Token::Tag.new "#tag"
			expect(parser.output).to eq token.printed
		end
		it "should process the value if it's a !!" do
			parser = Parser.new (Scanner.new "!!")
			expect(parser).to receive(:process)
			parser.parse
			expect(parser.output).to eq ""
		end
	end


end