require "eventmachine"


class SlowSMTPServer < EventMachine::Protocols::SmtpServer
  # We override EM's mail from processing to allow multiple mail-from commands
  # per [RFC 2821](http://tools.ietf.org/html/rfc2821#section-4.1.1.2)
  def process_mail_from sender
    if @state.include? :mail_from
      @state -= [:mail_from, :rcpt, :data]
      receive_reset
    end

    super
  end

  def current_message
    @current_message ||= {}
  end

  def receive_reset
    @current_message = nil
    true
  end

  def receive_sender(sender)
    current_message[:sender] = sender
    true
  end

  def receive_recipient(recipient)
    current_message[:recipients] ||= []
    current_message[:recipients] << recipient
    true
  end

  def receive_data_chunk(lines)
    current_message[:source] ||= ""
    lines.each do |line|
      current_message[:source] << line << "\r\n"
    end
    true
  end

  def receive_message
    puts "==> SMTP: Received message from '#{current_message[:sender]}' (#{current_message[:source].length} bytes)"
    puts "--> Going to Sleep for 40 seconds"
    sleep(40)
    true
  rescue
    puts "*** Error receiving message: #{current_message.inspect}"
    puts "    Exception: #{$!}"
    puts "    Backtrace:"
    $!.backtrace.each do |line|
      puts "       #{line}"
    end
    puts "    Please submit this as an issue at http://github.com/sj26/mailcatcher/issues"
    false
  ensure
    @current_message = nil
  end
end

EventMachine.run {
  EventMachine.start_server "127.0.0.1", 8081, SlowSMTPServer
}