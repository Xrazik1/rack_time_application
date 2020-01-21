class TimeFormatter
  TIME_FORMAT_KEYS = {
    year: '%Y',
    month: '%m',
    day: '%d',
    hour: '%I',
    minute: '%M',
    second: '%S'
  }.freeze

  def initialize(format_params)
    @format_params = format_params
  end

  def call
    @format_params = @format_params.map(&:to_sym)
  end

  def time_by_format
    raise 'Format parameters are in incorrect format' unless valid_format?

    format_time(@format_params)
  end

  def unknown_format_params
    return nil if valid_format?

    @format_params - TIME_FORMAT_KEYS.keys
  end

  def valid_format?
    return false unless @format_params.instance_of?(Array)

    (@format_params - TIME_FORMAT_KEYS.keys).empty?
  end

  private

  def format_time(params)
    string_keys = params.map { |time| TIME_FORMAT_KEYS[time] }.join('-')
    Time.new.strftime(string_keys)
  end

end
