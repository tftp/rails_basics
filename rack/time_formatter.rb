class TimeFormatter

  AVAILABLE_FORMAT = %w(year month day hour minute second)

  def initialize (query_string)
    @query_string = query_string
    @received_format = @query_string.split('-')
  end

  def responce
    return unless unknown_format.empty?
    @received_format.map! do |format|
      format = 'min' if format == 'minute'
      format = 'sec' if format == 'second'
      Time.now.send(format.to_sym)
    end
    @received_format.join('-')
  end

  def unknown_format
    @unknown_format = @received_format - AVAILABLE_FORMAT
  end

end
