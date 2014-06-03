require 'logger'
require 'colored'

class Log < Logger

  def format_message(severity, timestamp, progname, msg)
    if severity == 'DEBUG'
      "#{Time.now.strftime('%Y-%m-%d %X')} [#{severity}][#{self.calling_method}][#{self.line_calling_method}] ::#{msg}\n"
    elsif severity == 'WARN'
      "#{Time.now.strftime('%Y-%m-%d %X')} [#{severity}][#{self.calling_method}][#{self.line_calling_method}] ::#{msg}\n".magenta.bold
    elsif severity == 'INFO'
      "#{Time.now.strftime('%Y-%m-%d %X')} [#{severity}][#{self.calling_method}][#{self.line_calling_method}] :: #{msg}\n".green.bold
    elsif severity == 'ERROR'
      "#{Time.now.strftime('%Y-%m-%d %X')} [#{severity}][#{self.calling_method}][#{self.line_calling_method}] ::#{msg}\n".red.bold
    elsif severity == 'FATAL'
      "#{Time.now.strftime('%Y-%m-%d %X')} [#{severity}][#{self.calling_method}][#{self.line_calling_method}] ::#{msg}\n".black.blue.to_eol.bold
    else
      "#{Time.now.strftime('%Y-%m-%d %X')} [#{severity}][#{self.calling_method}][#{self.line_calling_method}] ::#{msg}\n".blue
    end

  end

  def deprecated(progname = nil, &block)
    add(DEPRECATED, nil, progname, &block)
  end

  #get name of the file where method is called
  def calling_method
    caller[3] =~ /.*\/(.*?)\:\d+/ and $1
  end

  #get line number of the file where method is called
  def line_calling_method
    caller[3] =~ /.*\/.*?\:(\d+)/ and $1
  end

  #  def deprecated(progname = nil, &block)
  #    add(DEPRECATED, nil, progname, &block)
  #  end


end
