require 'spec_helper'

describe Scanner do
	describe '#nextToken' do
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

		it "should return a WORD token if input is a word" do
			scanner = Scanner.new "hello"
			token = scanner.nextToken
			expect(token).to eq(Token::Word.new "hello")
		end

		it "should return a WORD token if input is a word with letters and digits, starting by a letter" do
			scanner = Scanner.new "hi5"
			token = scanner.nextToken
			expect(token).to eq(Token::Word.new "hi5")
		end

		it "should return a WORD token if input is a word with accented characters" do
			scanner = Scanner.new "Cañón"
			token = scanner.nextToken
			expect(token).to eq(Token::Word.new "Cañón")
		end

		it "should return a WORD token cutting off final characters different than letters or digits" do
			scanner = Scanner.new "hello!,"
			token = scanner.nextToken
			expect(token).to eq(Token::Word.new "hello")
		end

		it "should return a WORD token if input is the word has a hyphen" do
			scanner = Scanner.new "sub-project"
			token = scanner.nextToken
			expect(token).to eq(Token::Word.new "sub-project")
		end

		it "should return a NUMBER token if input is a number" do
			scanner = Scanner.new "2"
			token = scanner.nextToken
			expect(token).to eq(Token::Number.new "2")
		end

		it "should return a NUMBER token if input is a real" do
			scanner = Scanner.new "43.67"
			token = scanner.nextToken
			expect(token).to eq(Token::Number.new "43.67")
		end

		it "should return a NUMBER token if input is a negative number" do
			scanner = Scanner.new "-43.67"
			token = scanner.nextToken
			expect(token).to eq(Token::Number.new "-43.67")
		end

		it "should return a NUMBER + PUNCT token if input is a number finishing with a point" do
			scanner = Scanner.new "45."
			token = scanner.nextToken
			expect(token).to eq(Token::Number.new "45")
			token = scanner.nextToken
			expect(token).to eq(Token::Punctuation.new ".")
		end

		it "should return a NUMBER + PUNCT token if input is a number with two points" do
			scanner = Scanner.new "45.75.78"
			token = scanner.nextToken
			expect(token).to eq(Token::Number.new "45.75")
			token = scanner.nextToken
			expect(token).to eq(Token::Punctuation.new ".")
			token = scanner.nextToken
			expect(token).to eq(Token::Number.new "78")
		end

		it "should return a NUMBER + WORD tokens if input is a word with letters and digits, starting by a digit" do
			scanner = Scanner.new "1mpossible"
			token = scanner.nextToken
			expect(token).to eq(Token::Number.new "1")
			token = scanner.nextToken
			expect(token).to eq(Token::Word.new "mpossible")
		end

		it "should return a PUNCTUATION token if input is a punctuation sign" do
			scanner = Scanner.new "!"
			token = scanner.nextToken
			expect(token).to eq(Token::Punctuation.new "!")
		end

		it "should return a EMAIL token if input matches a valid email address" do
			scanner = Scanner.new "pachisaez@hotmail.com"
			token = scanner.nextToken
			expect(token).to eq(Token::Email.new "pachisaez@hotmail.com")
		end

		it "should return an URL token if iput matches a url" do
			scanner = Scanner.new "https://twitter.com"
			token = scanner.nextToken
			expect(token).to eq(Token::Url.new "https://twitter.com")
		end

		it "should return a TAG token if input is a tag" do
			scanner = Scanner.new "#tag_name"
			token = scanner.nextToken
			expect(token).to eq(Token::Tag.new "#tag_name")
		end

		it "should return a PUNCTUATION token if input doesn't match a tag after #" do
			scanner = Scanner.new "# tag_name"
			token = scanner.nextToken
			expect(token).to eq(Token::Punctuation.new "#")
		end

		it "should return a ENTITY token if input is a person" do
			scanner = Scanner.new "@pachi"
			token = scanner.nextToken
			expect(token).to eq(Token::Entity.new "@pachi")
		end

		it "should return a PUNCTUATION token if input doesn't match an entity after @" do
			scanner = Scanner.new "@."
			token = scanner.nextToken
			expect(token).to eq(Token::Punctuation.new "@")
		end

		it "should return a FOCUS token if input is !!" do
			scanner = Scanner.new "!!"
			token = scanner.nextToken
			expect(token).to eq(Token::Focus.new)
		end

		it "should return a PUNCTUATION token if input doesn't match focus after !" do
			scanner = Scanner.new "!."
			token = scanner.nextToken
			expect(token).to eq(Token::Punctuation.new "!")
		end

		it "should return a COMMAND token if input is a correct command" do
			scanner = Scanner.new ":day"
			token = scanner.nextToken
			expect(token).to eq(Token::Command.new ":day")
		end

		it "should return a PUNCTUATION token if input doesn't match a command after :" do
			scanner = Scanner.new ":shit"
			token = scanner.nextToken
			expect(token).to eq(Token::Punctuation.new ":")
		end
	end

	describe '#tokens' do
		it "should return a list of tokens" do
			scanner = Scanner.new "hello, world!"
			tokens = scanner.tokens
			expect(tokens).to be_an Array
		end

		it "should return all the specific tokens" do
			scanner = Scanner.new "hello, world!"
			tokens = scanner.tokens
			expect(tokens[0]).to eq(Token::Word.new "hello")
			expect(tokens[1]).to eq(Token::Punctuation.new ",")
			expect(tokens[2]).to eq(Token::Space.new)
			expect(tokens[3]).to eq(Token::Word.new "world")
			expect(tokens[4]).to eq(Token::Punctuation.new "!")
			expect(tokens[5]).to eq(Token::Eos.new)
		end
	end

end