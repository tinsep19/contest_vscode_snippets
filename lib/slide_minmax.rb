class Array
  # slide_min(w){|l, r, min| ... }
  def slide_min(w)
    return enum_for(:slide_min, w) unless block_given?

    min_events = []; min_values = []
    each_with_index do |v, t|
      (min_events.shift; min_values.shift) until min_events.empty? || t - min_events[0] < w
      (min_events.pop; min_values.pop) until min_values.empty? || min_values[-1] < v
      min_events << t; min_values << v
      yield t + 1 - w, t + 1, min_values[0] if t + 1 >= w
    end
  end
  # slide_max(w){|l, r, max| ... }
  def slide_max(w)
    return enum_for(:slide_max, w) unless block_given?

    max_events = []; max_values = []
    each_with_index do |v, t|
      (max_events.shift; max_values.shift) until max_events.empty? || t - max_events[0] < w
      (max_events.pop; max_values.pop) until max_values.empty? || max_values[-1] > v
      max_events << t; max_values << v
      yield t + 1 - w, t + 1, max_values[0] if t + 1 >= w
    end
  end
  # slide_minmax(w){|l, r, min, max| ... }
  def slide_minmax(w)
    return enum_for(:slide_minmax, w) unless block_given?

    min_events = []; min_values = []
    max_events = []; max_values = []
    each_with_index do |v, t|
      (min_events.shift; min_values.shift) until min_events.empty? || t - min_events[0] < w
      (max_events.shift; max_values.shift) until max_events.empty? || t - max_events[0] < w
      (min_events.pop; min_values.pop) until min_values.empty? || min_values[-1] < v
      (max_events.pop; max_values.pop) until max_values.empty? || max_values[-1] > v
      min_events << t; min_values << v
      max_events << t; max_values << v
      yield t + 1 - w, t + 1, min_values[0], max_values[0] if t + 1 >= w
    end
  end
end

