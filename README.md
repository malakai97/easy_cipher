# EasyCipher

A simple gem that uses ruby's OpenSSL package to simplify normal cipher use.
It does not rely on any external libraries.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy_cipher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy_cipher

## Usage

### To create an entirely new cipher
```ruby
cipher = EasyCipher::Cipher.new
encrypted_data = cipher.encrypt "my data"
decrypted_data = cipher.decrypt encrypted_data
=> "my data"

cipher.key
=> "ZE\xD9\xE2B\n2J1\xDF\x10$\x03A\xB95\xE9P\xDF\xD5\xF6\xAA<\x06C\x82~\x06]\xBB\xE1G"

cipher.iv
=> "QHB\xE6\xEDpE\xDCha\x80\x02\xDB\xA5A\xAB"
```

### To create a cipher from a known key, iv
```ruby
known_cipher = EasyCipher::Cipher.new(known_key, known_iv)

# then use it as normal.
```

### You can also create from base64 encoded values
```ruby
key64 = my_first_cipher.key64
iv64 = my_first_cipher.iv64
new_cipher = EasyCipher::Cipher.new64(key64,iv64)

# then use it as normal.
# Base64 encodings work with SQL string fields.
```

## Contributing

1. Fork it ( https://github.com/malakai97/easy_cipher/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
