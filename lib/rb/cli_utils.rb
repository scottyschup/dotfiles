require 'colorize'

class CLIUtils
  MSG_TYPE_TO_METHOD_AND_COLOR_MAP = {
    log: [:puts, nil],
    info: [:puts, :cyan],
    warn: [:warn, :yellow],
    error: [:warn, :red],
    success: [:puts, :green],
    partial: [:print, nil],
  }

  class << self
    def message_block(msg_arr, type: :log, new_line: false)
      $stdout.send(MSG_TYPE_TO_METHOD_AND_COLOR_MAP[type], '') if new_line
      skip_display_type = false

      msg_arr.each do |msg, msg_type|
        curr_type = msg_type || type
        method, color = MSG_TYPE_TO_METHOD_AND_COLOR_MAP[curr_type]

        display_type = skip_display_type ?
          '' :
          (msg_type == :partial ? type : curr_type).to_s.upcase.colorize(color)

        $stdout.send(method, "#{skip_display_type ? '' : "[#{display_type}]  "}#{msg}".colorize(color))

        skip_display_type = msg_type == :partial
      end
    end
  end
end
