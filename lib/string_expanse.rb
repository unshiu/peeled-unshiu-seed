class String
  
  def strip_with_full_size_space!
    self.replace(strip_with_full_size_space)
  end
  
  def strip_with_full_size_space
    s = "　\s\v"
    self =~ /^[#{s}]+([^#{s}]+)[#{s}]+$/ ? $1 : self
  end
end