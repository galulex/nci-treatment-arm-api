class Hash
  def delete_keys!(*keys)
    keys.flatten.each do |k|
      delete(k)
    end
    self
  end

  def delete_keys(*keys)
    kdup = dup
    keys.flatten.each do |k|
      kdup.delete(k)
    end
    kdup
  end
end