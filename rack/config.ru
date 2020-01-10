require_relative 'middleware/runtime'
require_relative 'middleware/logger'
require_relative 'app'

use Runtime
# options for logger
# use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
use AppLogger
run App.new
