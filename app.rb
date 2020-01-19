class TimeHandler


  def initialize
    @response_code = 200
    @response_headers = {'Content-type' => 'text/plain'}
    @response_body = ''
  end

  def call(env)
    handle_query(env['QUERY_STRING'])

    [
      @response_code,
      @response_headers,
      @response_body
    ]
  end


end
