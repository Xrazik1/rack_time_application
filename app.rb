class TimeHandler
  VALID_TIME_KEYS = %w[year month day hour minute second].freeze

  def initialize
    @response_code = 200
    @response_headers = {'Content-type' => 'text/plain'}
    @response_body = ''
  end

  def call(env)
    if env['REQUEST_PATH'] == '/time'
      handle_query(env['QUERY_STRING'])
    else
      @response_code = 404
      @response_body = ["Request path #{env['REQUEST_PATH']} does not exists\n"]
    end

    [
      @response_code,
      @response_headers,
      @response_body
    ]
  end

  def valid_params?(params)
    return false unless params.instance_of?(Array)

    (params - VALID_TIME_KEYS).empty?
  end

  def handle_query(query)
    params = query.split('=').last.split('%2C')

    valid_params?(params) ? handle_time(params) : handle_bad_format(params)
  end

  def handle_time(params)
    converted = convert_time(params)
    time = Time.new
    string_time = converted.join('-')

    @response_body = ["#{time.strftime(string_time)}\n"]
    @response_code = 200
  end

  def handle_bad_format(params)
    @response_code = 400
    @response_body = ["Unknown time format #{params}\n"]
  end

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
