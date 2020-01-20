require_relative 'time_formatter'

class App
  def initialize
    @response_code = 200
    @response_headers = {'Content-type' => 'text/plain'}
    @response_body = ''
  end

  def call(env)
    if valid_request_path? env['REQUEST_PATH']
      handle_query(env['QUERY_STRING'])
    else
      handle_bad_request_path(env['REQUEST_PATH'])
    end

    [
      @response_code,
      @response_headers,
      @response_body
    ]
  end

  def valid_request_path?(path)
    path == '/time'
  end

  def handle_query(query)
    params = query.split('=').last.split('%2C')

    if TimeFormatter.valid_keys?(params)
      @response_code = 200
      @response_body = ["#{TimeFormatter.new.time_in_format(params)}\n"]
    else
      handle_bad_format(params)
    end
  end

  def handle_bad_request_path(path)
    @response_code = 404
    @response_body = ["Request path #{path} does not exists\n"]
  end

  def handle_bad_format(params)
    @response_code = 400
    @response_body = ["Unknown time format #{params}\n"]
  end
end
