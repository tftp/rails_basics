class App
  require_relative 'time_formatter'

  def call(env)

    params = TimeFormatter.new(env).start
    [params[:status], params[:headers], params[:body]]
  end

end
