
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

    @encryptor = OpenSSL::Cipher::AES256.new(:CBC)
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

    @decryptor = OpenSSL::Cipher::AES256.new(:CBC)
    @decryptor.decrypt
    @decryptor.key = @key
    @decryptor.iv = @iv
  end


  # Encrypt the given data.  If you want to directly save this to
  # a string SQL column, you must base64 encode OR a binary column.
  # Alternatively, @see #encrypt_to_base64
  # @param data [String] The data to encrypt
  # @return [String] The encrypted data.
  def encrypt(data)
    return encrypt_line(data, true)
  end


  # Encrypt the given data, and return it base64 encoded.
  # Best for use when the result must be saved to a string column.
  # @param data [String] the data to encrypt
  # @return [String] The encrypted data, base64 encoded.
  def encrypt_to_base64(data)
    return Base64.encode64(encrypt(data))
  end


  # Decrypt the given data.  For use with encrypt.
  # @see #encrypt.
  # @param encrypted_data [String]
  # @return [String] The decrypted data.
  def decrypt(encrypted_data)
    return decrypt_line(encrypted_data, true)
  end


  # Decrypt the given data.  For use with encrypt_to_string.
  # @see #encrypt_to_base64
  # @param encrypted_data [String] Base64 encoded.
  # @return [String] The decrypted data.
  def decrypt_from_base64(encrypted_data)
    return decrypt_line(Base64.decode64(encrypted_data))
  end


  protected
  def encrypt_line(line, final = true)
    output = @encryptor.update(line)
    if final
      output << @encryptor.final
    end
    return output
  end


  def decrypt_line(line, final = true)
    output = @decryptor.update(line)
    if final
      output << @decryptor.final
    end
    return output
  end


end