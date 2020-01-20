class TimeFormatter
  VALID_TIME_KEYS = %w[year month day hour minute second].freeze

  def self.valid_format?(keys)
    return false unless keys.instance_of?(Array)

    (keys - VALID_TIME_KEYS).empty?
  end

  def time_by_format(keys)
    converted = convert_time(keys)
    time = Time.new
    string_time = converted.join('-')

    time.strftime(string_time)
  end

  private

  def convert_time(params)
    params.map do |time|
      if %w[day month].include? time
        "%#{time.split('').first}"
      elsif %w[minute second year].include? time
        "%#{time.split('').first.upcase}"
      elsif time == 'hour'
        '%I'
      end
    end
  end

end
