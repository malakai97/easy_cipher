require "openssl"
require "base64"

# The cipher class
class EasyCipher::Cipher
  attr_reader :key, :iv

  # Create a new cipher instance.
  # @param key [String] A 256bit random key, or nil.
  # @param iv [String] An initialization vector, or nil.
  def initialize(key = nil, iv = nil)
    if (key && !iv) || (!key && iv)
      raise ArgumentError, "Must supply key AND iv, or neither."
    end

    @key = key
    @iv = iv

    @encryptor = ::OpenSSL::Cipher::AES256.new(:CBC)
    @encryptor.encrypt

    if @key
      @encryptor.key = @key
    else
      @key = @encryptor.random_key
    end

    if @iv
      @encryptor.iv = @iv
    else
      @iv = @encryptor.random_iv
    end

    @decryptor = ::OpenSSL::Cipher::AES256.new(:CBC)
    @decryptor.decrypt
    @decryptor.key = @key
    @decryptor.iv = @iv
  end

  # Create a new cipher instance.
  # @param key [String] A 256bit random key, base64 encoded.
  # @param iv [String] An initialization vector, base64 encoded.
  def self.new64(key, iv)
    return self.new(Base64.decode64(key), Base64.decode64(iv))
  end

  # Return the key in base64 (e.g. to store in string fields)
  def key64
    return Base64.encode64(@key)
  end

  # Return the iv in base64 (e.g. to store in string fields)
  def iv64
    return Base64.encode64(@iv)
  end

  # Encrypt the given data.
  # @param data [String] The data to encrypt
  # @return [String] Base64 representation of the encrypted data.
  def encrypt(data)
    return Base64.encode64(encrypt_line(data, true))
  end


  # Decrypt the given data.
  # @param encrypted_data [String] Base64 representation of the encrypted data.
  # @return [String] The decrypted data.
  def decrypt(encrypted_data)
    return decrypt_line(Base64.decode64(encrypted_data), true)
  end



  protected
  def encrypt_line(line, final = true)
    @encryptor.reset
    output = @encryptor.update(line)
    if final
      output << @encryptor.final
    end
    return output
  end


  def decrypt_line(line, final = true)
    @decryptor.reset
    output = @decryptor.update(line)
    if final
      output << @decryptor.final
    end
    return output
  end


end