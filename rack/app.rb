class App

  def call(env)

    params = processing_parameters(env)
    [params[:status], headers, params[:body]]
  end

end

private

def headers
  { 'Content-Type' => 'text/plain' }
end

def processing_parameters(env)
  params = {}
  query_string = env['QUERY_STRING'].split('=')

  if query_string[0] != 'format' || env['REQUEST_PATH'] != '/time' || query_string[1].nil?
    params[:body] = ["Not found \n"]
    params[:status] = 404
    return params
  end

  available_format = %w(year month day hour minute second)
  received_format = query_string[1].nil? ? '' : env['QUERY_STRING'].split('=')[1].split('-')
  unknown_format = received_format - available_format

  unless unknown_format.empty?
    params[:body] = ["Unknown time format [#{unknown_format.join(', ')}] \n"]
    params[:status] = 400
    return params
  end

  received_format.map! do |format|
    format = 'min' if format == 'minute'
    format = 'sec' if format == 'second'
    Time.now.send(format.to_sym)
  end
  params[:body] = [received_format.join('-')]
  params[:status] = 200
  return params

end
