class Array
  def lower_index(&block)
    l = -1; r = self.size
    block[self[mid = (l + r) / 2]] ? (r = mid) : (l = mid) while l + 1 < r
    return r < self.size ? r : nil
  end  
  def upper_index(&block)
    l = -1; r = self.size
    block[self[mid = (l + r) / 2]] ? (l = mid) : (r = mid) while l + 1 < r
    return l < 0 ? nil : l
  end
  def lower_bound(&block)
    l = -1; r = self.size
    block[self[mid = (l + r) / 2]] ? (r = mid) : (l = mid) while l + 1 < r
    return r < self.size ? self[r] : nil
  end
  def upper_bound(&block)
    l = -1; r = self.size
    block[self[mid = (l + r) / 2]] ? (l = mid) : (r = mid) while l + 1 < r
    return l < 0 ? nil : self[l]
  end
end
class Range
  def lower_bound(&block)
    l = self.begin - 1; r = self.end + 1
    r -= 1 if exclude_end?
    e = r
    block[(mid = (l + r) / 2)] ? (r = mid) : (l = mid) while l + 1 < r
    return r < e ? r : nil
  end
  def upper_bound(&block)
    l = self.begin - 1; r = self.end + 1
    r -= 1 if exclude_end?
    block[(mid = (l + r) / 2)] ? (l = mid) : (r = mid) while l + 1 < r
    return l < self.begin ? nil : l
  end
end
