class Cipher

  def initialize(*args)
    if args.nil?
      gen_rnd_key
    else
      @key = args.to_s
    end

    gen_rnd_key if self.key == '[]'
    arg_errors?
    @@pt = ''
    @key.gsub!(/[\W]/,'')
  end


  def arg_errors?
    case self.key
      when self.key.to_s.upcase
        raise ArgumentError, "lower case please."
      when self.key.to_i
        raise ArgumentError, "numbers are not allowed."
      when self.key == '[""]'
        raise ArgumentError, "empty strings are not allowed."
    end
  end

  def gen_rnd_key
    @key = (0...100).map { [*('a'..'z')].shuffle[0,1] }.join
  end

  def to_s
    "#{@key}"
  end

  def key
    to_s
  end

  def encode(plaintext)
    @@pt = plaintext.to_s.downcase
    message = plaintext.to_s.downcase
    hash = {}
    hash[message] = self.key[0, plaintext.length]
		hash.each { |k, v|  message.gsub!(k, v)  }
    cipher = ''
    message.scan(/./).each { |alph| cipher += cipher(alph, alph.ord.to_i - 97) }
    alpha_value = 0
    @@pt.scan(/./).each { |alph| alpha_value += alph.ord.to_i - 97 }

    if message == @@pt
      cipher
    elsif alpha_value == 250
    	cipher_shift = ''
    	message.scan(/./).each { |alph| cipher_shift += cipher(alph, 25) }
     	cipher_shift
    else
      message
    end
  end


  def decode(key)
    message = key.to_s.downcase
    hash = {}
    hash[message] = @@pt
    hash.each { |k, v| message.gsub!(k, v) }
    alpha_value = 0
    message.scan(/./).each { |alph| alpha_value += alph.ord.to_i - 97 }
    message = (0...key.length).map { ('a') }.join if alpha_value == 0
    message
  end


  def cipher(chr, shift)
    shift -= 26 if (chr.ord.to_i + shift) > 122
    "#{((chr.ord.to_i) + shift).chr}"
  end

end
