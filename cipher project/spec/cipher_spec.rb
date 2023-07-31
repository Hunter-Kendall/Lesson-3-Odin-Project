require './lib/cipher'

describe Cipher do
    describe "#changes string" do
        it "returns a string not equal to origional" do
            cipher = Cipher.new
            expect(cipher.encript("hello", 1)).not_to eql("hello")
        end
        it "returns not nil" do
            cipher = Cipher.new
            expect(cipher.encript("hello", 1)).not_to eql(nil)
        end 
    end
    describe "#jumps properly" do
        it "jumps once from a to b" do
            cipher = Cipher.new
            expect(cipher.encript("a", 1)).to eql("b")
        end
        it "wraps z to a" do
            cipher = Cipher.new
            expect(cipher.encript("z", 1)).to eql("a")
        end
        it "wraps Z to A" do
            cipher = Cipher.new
            expect(cipher.encript("Z", 1)).to eql("A")
        end

    end

    describe "#encrypts messages" do
        it "allows ,.! and spaces" do
            cipher = Cipher.new
            expect(cipher.encript("A b,.!", 1)).to eql("B c,.!")
        end
    end
end