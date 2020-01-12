class App
  require_relative 'time_formatter'

  def call(env)
    @query_string = env['QUERY_STRING'].split('=')
    @request_path = env['REQUEST_PATH']

    if checking_for_404?
      return [ 404,
               headers,
               ["Not found \n"] ]
    end

    @time_formatter = TimeFormatter.new(@query_string[1])

    if checking_for_400?
      return [ 400,
               headers,
               ["Unknown time format [#{@time_formatter.unknown_format.join(', ')}] \n"] ]
    end

    [ 200,
      headers,
      [@time_formatter.responce] ]
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def checking_for_404?
    @query_string[0] != 'format' || @request_path != '/time' || @query_string[1].nil?
  end

  def checking_for_400?
    !@time_formatter.unknown_format.empty?
  end

end
