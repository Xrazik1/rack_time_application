# frozen_string_literal: true

require_relative 'time_formatter'
require 'rack'

class App
  def initialize
    @headers = { 'Content-type' => 'text/plain' }
  end

  def call(env)
    if valid_request_path? env['REQUEST_PATH']
      handle_query(env['QUERY_STRING'])
    else
      response(404, "Request path #{env['REQUEST_PATH']} does not exists\n")
    end
  end

  def handle_query(query)
    params    = query.split('=').last.split('%2C')
    formatter = TimeFormatter.new(params)
    formatter.call

    if formatter.valid_format?
      response(200, formatter.time_by_format)
    else
      response(200, "Unknown time formats were found #{formatter.unknown_format_params}\n")
    end
  end

  def response(status, body)
    Rack::Response.new(body, status, @headers).finish
  end

  def valid_request_path?(path)
    path == '/time'
  end
end
