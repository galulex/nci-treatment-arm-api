class Hash
  def delete_keys!(*keys)
    keys.flatten.each do |k|
      delete(k)
    end
    self
  end
end
