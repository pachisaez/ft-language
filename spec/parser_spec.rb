require 'spec_helper'
require 'colorize'

describe Parser do
	describe '#initialize' do
		it "should get a list of tokens" do
			parser = Parser.new (Grammar.new "hello, world!")

			expect(parser.tokens[0]).to be_a Token::Base
			expect(parser.tokens.size).to eq 6
		end
	end

	describe "#expr" do
		it "should print the value if it's printable" do
			parser = Parser.new (Grammar.new "hello")
			parser.parse
			token = Token::Chunk.new "hello"
			expect(parser.output).to eq token.printed
		end
		it "should print and process the value if it's a tag" do
			parser = Parser.new (Grammar.new "#tag")
			expect(parser).to receive(:process)
			parser.parse
			token = Token::Tag.new "#tag"
			expect(parser.output).to eq token.printed
		end
		it "should process the value if it's a !!" do
			parser = Parser.new (Grammar.new "!!")
			expect(parser).to receive(:process)
			parser.parse
			expect(parser.output).to eq ""
		end

		it "should process the command urgent" do
			parser = Parser.new (Grammar.new ":urgent")
			expect(STDOUT).to receive(:puts).with('urgent')
			parser.parse
		end

		it "should process the command energy low" do
			parser = Parser.new (Grammar.new ":energy low")
			expect(STDOUT).to receive(:puts).with('energy low')
			parser.parse
		end
		it "should not process the command energy whatever" do
			parser = Parser.new (Grammar.new ":energy whatever")
			expect(STDOUT).to receive(:puts).with("energy error".colorize(:red))
			parser.parse
			expect(parser.output).to eq ":energy whatever ".colorize(:red)
		end

		it "should process the command time 15 min" do
			parser = Parser.new (Grammar.new ":time 15 min")
			expect(STDOUT).to receive(:puts).with('time 15 minutes')
			parser.parse
		end
		it "should process the command time 2 hours" do
			parser = Parser.new (Grammar.new ":time 2 hours")
			expect(STDOUT).to receive(:puts).with('time 120 minutes')
			parser.parse
		end
		it "should not process the command time wrong" do
			parser = Parser.new (Grammar.new ":time wrong")
			expect(STDOUT).to receive(:puts).with("time error".colorize(:red))
			parser.parse
			expect(parser.output).to eq ":time wrong ".colorize(:red)
		end
		it "should not process the command time 15 eggs" do
			parser = Parser.new (Grammar.new ":time 15 eggs")
			expect(STDOUT).to receive(:puts).with("time error".colorize(:red))
			parser.parse
			expect(parser.output).to eq ":time 15 eggs ".colorize(:red)
		end

	end


end