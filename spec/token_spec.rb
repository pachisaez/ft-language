require 'spec_helper'

describe Token::Base do
	it "should have type and value" do
		token = Token::Base.new Token::Base::COMMAND, "day"

		expect(token.type).to eq(Token::Base::COMMAND)
		expect(token.value).to eq("day")
	end

	describe "comparison" do
		it "should return true if two tokens have the same type and value" do
			compare = Token::Base.new(Token::Base::CHUNK, "hello")== Token::Base.new(Token::Base::CHUNK, "hello")

			expect(compare).to be true
		end
		it "should return flase if two tokens have different types" do
			compare = Token::Base.new(Token::Base::CHUNK, "day")== Token::Base.new(Token::Base::COMMAND, "day")

			expect(compare).to be false
		end
		it "should return flase if two tokens have different values" do
			compare = Token::Base.new(Token::Base::CHUNK, "hello")== Token::Base.new(Token::Base::CHUNK, "hallo")

			expect(compare).to be false
		end
	end

	describe "#last?" do
		it "should return true if it's the last input token" do
			token = Token::Base.new Token::Base::EOS, nil

			expect(token.last?).to be true
		end
		it "should return true if it's not the last input token" do
			token = Token::Base.new Token::Base::EXCEPTION, "$"

			expect(token.last?).to be false
		end
	end
end