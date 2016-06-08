class String
  def hexencode
    self.unpack('H*').first
  end

  def hexdecode
    [self].pack('H*')
  end
end
