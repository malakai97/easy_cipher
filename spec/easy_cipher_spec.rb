require 'spec_helper'

describe EasyCipher do
  it "has a version number" do
    expect(EasyCipher::VERSION).not_to be nil
  end

  describe EasyCipher::Cipher do
    context "without supplying key, iv" do
      subject { EasyCipher::Cipher.new() }

      it "mints a key" do
        expect(subject.key).to be_a String
      end

      it "mints an inv" do
        expect(subject.iv).to be_a String
      end

      it "decrypts stuff it encrypts" do
        data = "here is some data"
        expect {
          processed_data = subject.decrypt(subject.encrypt(data))
          expect(processed_data).to eql(data)
        }.to_not raise_error

      end
    end

    context "with supplied key, iv" do
      before(:each) do
        @key = "~\x83\x17\x82\t\xCC\xDF\x12\xC7j\xD6\xD2?FW[\xA4\xE1es\x97\xAA\x9F\b\x9B&\x89C\xFD\t\x96\xAA"
        @iv = "/mw\x05\xE6\x1A+\x84\x03\e\xC9+Q\xA0\x98\x9C"
        @key64 = "foMXggnM3xLHatbSP0ZXW6ThZXOXqp8ImyaJQ/0Jlqo=\n"
        @iv64 = "L213BeYaK4QDG8krUaCYnA==\n"
        @expected_secret = "Nz74abAflmXhDAGfITCF0w==\n"
        @data = "blarg"
      end

      shared_examples "a cipher" do
        it "does not change the key" do
          expect(Base64.encode64(subject.key)).to eql(@key64)
        end

        it "does not change the iv" do
          expect(Base64.encode64(subject.iv)).to eql(@iv64)  # We do this to avoid failing on different
        end                                                  # representations of the same character.

        it "encrypts the data" do
          expect(subject.encrypt(@data)).to eql(@expected_secret)
        end

        it "decrypts the data" do
          expect(subject.decrypt(@expected_secret)).to eql(@data)
        end

        it "returns the  base64 encoded key" do
          expect(subject.key64).to eql(@key64)
        end

        it "returns the base64 encoded iv" do
          expect(subject.iv64).to eql(@iv64)
        end

        it "encrypts the same consecutively" do
          expect(subject.encrypt(@data)).to eql(@expected_secret)
          expect(subject.encrypt(@data)).to eql(@expected_secret)
          expect(subject.encrypt(@data)).to eql(@expected_secret)
          expect(subject.encrypt(@data)).to eql(@expected_secret)
        end

        it "decrypts the same consecutively" do
          expect(subject.decrypt(@expected_secret)).to eql(@data)
          expect(subject.decrypt(@expected_secret)).to eql(@data)
          expect(subject.decrypt(@expected_secret)).to eql(@data)
          expect(subject.decrypt(@expected_secret)).to eql(@data)
        end
      end

      context "not as base64" do
        subject { EasyCipher::Cipher.new(@key, @iv) }
        it_behaves_like "a cipher"
      end

      context "as base64" do
        subject {  EasyCipher::Cipher.new64(@key64, @iv64) }
        it_behaves_like "a cipher"
      end

    end


  end





end
