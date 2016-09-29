class Hash
  def delete_keys!(*keys)
    keys.flatten.each do |k|
      delete(k)
    end
    self
  end

  def delete_keys(*keys)
    _dup = dup
    keys.flatten.each do |k|
      _dup.delete(k)
    end
    _dup
  end
end