class TimeFormatter

  AVAILABLE_FORMAT = %w(year month day hour minute second)

  def initialize (env)
    @query_string = env['QUERY_STRING']
    @request_path = env['REQUEST_PATH']
    @params = {}
  end

  def start
    query_string = @query_string.split('=')

    if checking_for_404?
      @params = { body: ["Not found \n"],
                  status: 404,
                  headers: headers }
      return @params
    end

    if checking_for_400?
      @params = { body: ["Unknown time format [#{unknown_format.join(', ')}] \n"],
                  status: 400,
                  headers: headers }
      return @params
    end

    received_format_convertation!

    @params = { body: [@received_format.join('-')],
                status: 200,
                headers: headers }
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def checking_for_404?
    query_string = @query_string.split('=')
    query_string[0] != 'format' || @request_path != '/time' || query_string[1].nil?
  end

  def checking_for_400?
    !unknown_format.empty?
  end

  def unknown_format
    query_string = @query_string.split('=')
    @received_format = query_string[1].nil? ? '' : query_string[1].split('-')
    unknown_format = @received_format - AVAILABLE_FORMAT
  end

  def received_format_convertation!
    @received_format.map! do |format|
      format = 'min' if format == 'minute'
      format = 'sec' if format == 'second'
      Time.now.send(format.to_sym)
    end
  end

end
