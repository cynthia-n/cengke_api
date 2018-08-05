class EventLogger
  include Singleton
  attr_accessor :logger
  def initialize
    @logger = Logger.new("#{Rails.root}/log/event.log")
    @logger.formatter = EventLoggerrFormatter.new
  end

  class EventLoggerrFormatter < ::Logger::Formatter
    def call(severity, timestamp, progname, msg)
      "#{timestamp},#{msg}\n"
    end
  end
end

def flatten_hash hash, head=nil
  hash.map do |k,v|
    next if k.to_s.end_with?('file')
    next if k.to_s.start_with?('password')
    if v.class == Hash
      flatten_hash(v,"#{head}#{k}.")
    else
      "#{head}#{k}=#{v}"
    end
  end.compact.join(",")
end

# ActiveSupport::Notifications.instrument "action.event", {}

%w(grape.request action.event).each do |notify_name|
  ActiveSupport::Notifications.subscribe(notify_name) do |name, starts, ends, notification_id, payload|
    payload[:source_type] = "cengke_#{Rails.env}"
    payload[:notify_type] = notify_name
    EventLogger.instance.logger.info "#{flatten_hash payload.as_json}"
  end
end
