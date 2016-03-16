require 'spec_helper'

describe Scanner do
	describe '#next_token' do
		it "should return a token" do
			scanner = Scanner.new "hello"
			token = scanner.nextToken
			expect(token).to be_a(Token::Base)
		end

		it "should return an EOS token if input is empty" do
			scanner = Scanner.new
			token = scanner.nextToken
			expect(token).to eq(Token::Eos.new)
		end

		it "should return a CHUNK token if input is any chunk of characters ending in digit or letter" do
			scanner = Scanner.new "hello"
			token = scanner.nextToken
			expect(token).to eq(Token::Chunk.new "hello")
		end

		it "should return a CHUNK token cutting off final characters different than letter or digit" do
			scanner = Scanner.new "hello!,"
			token = scanner.nextToken
			expect(token).to eq(Token::Chunk.new "hello")
		end

		it "should return two CHUNK tokens cutting off final characters different than letter or digit" do
			scanner = Scanner.new "Hello, John"
			token = scanner.nextToken
			expect(token).to eq(Token::Chunk.new "Hello")
			token = scanner.nextToken
			expect(token).to eq(Token::Exception.new ",")
			token = scanner.nextToken
			expect(token).to eq(Token::Space.new)
			token = scanner.nextToken
			expect(token).to eq(Token::Chunk.new "John")
		end

		it "should return a EMAIL token if chunk matches a valid email address" do
			scanner = Scanner.new "pachisaez@hotmail.com"
			token = scanner.nextToken
			expect(token).to eq(Token::Email.new "pachisaez@hotmail.com")
		end

		it "should return an URL token if chunk matches a url" do
			scanner = Scanner.new "https://twitter.com"
			token = scanner.nextToken
			expect(token).to eq(Token::Url.new "https://twitter.com")
			scanner = Scanner.new "http://twitter.com"
			token = scanner.nextToken
			expect(token).to eq(Token::Url.new "http://twitter.com")
		end

		it "should return a CHUNK token if input is has numbers" do
			scanner = Scanner.new "hello123"
			token = scanner.nextToken
			expect(token).to eq(Token::Chunk.new "hello123")
		end

		it "should return a CHUNK token if input is has special characters" do
			scanner = Scanner.new "españa"
			token = scanner.nextToken
			expect(token).to eq(Token::Chunk.new "españa")
		end

		it "should return a CHUNK token if input is the word has a hyphen" do
			scanner = Scanner.new "sub-project"
			token = scanner.nextToken
			expect(token).to eq(Token::Chunk.new "sub-project")
		end

		it "should return CHUNK-SPACE-CHUNK-EXPECTION tokens if there is an space between" do
			scanner = Scanner.new "hello world!"
			token = scanner.nextToken
			expect(token).to eq(Token::Chunk.new "hello")
			token = scanner.nextToken
			expect(token).to eq(Token::Space.new)
			token = scanner.nextToken
			expect(token).to eq(Token::Chunk.new "world")
			token = scanner.nextToken
			expect(token).to eq(Token::Exception.new "!")
		end

		it "should return a SPACE token if input is a space, tab sequence" do
			scanner = Scanner.new "  \t"
			token = scanner.nextToken
			expect(token).to eq(Token::Space.new)
		end

		it "should return a NEW_LINE token if input is new line" do
			scanner = Scanner.new "\r\n"
			token = scanner.nextToken
			expect(token).to eq(Token::NewLine.new)
		end

		it "should return a FOCUS token if input is !!" do
			scanner = Scanner.new "!!"
			token = scanner.nextToken
			expect(token).to eq(Token::Focus.new)
		end

		it "should return a TAG token if input is a tag" do
			scanner = Scanner.new "#tag_name"
			token = scanner.nextToken
			expect(token).to eq(Token::Tag.new "#tag_name")
		end

		it "should return a ENTITY token if input is a person" do
			scanner = Scanner.new "@pachi"
			token = scanner.nextToken
			expect(token).to eq(Token::Entity.new "@pachi")
		end

		it "should return a COMMAND token if input is a correct command" do
			scanner = Scanner.new ":day"
			token = scanner.nextToken
			expect(token).to eq(Token::Command.new ":day")
		end
	end
	describe '#tokens' do
		it "should return a list of tokens" do
			scanner = Scanner.new "hello, world!"
			tokens = scanner.tokens
			expect(tokens).to be_an Array
		end
		it "should return all the tokens" do
			scanner = Scanner.new "hello, world!"
			tokens = scanner.tokens
			expect(tokens[0]).to eq(Token::Chunk.new "hello")
			expect(tokens[1]).to eq(Token::Exception.new ",")
			expect(tokens[2]).to eq(Token::Space.new)
			expect(tokens[3]).to eq(Token::Chunk.new "world")
			expect(tokens[4]).to eq(Token::Exception.new "!")
			expect(tokens[5]).to eq(Token::Eos.new)
		end
	end
end