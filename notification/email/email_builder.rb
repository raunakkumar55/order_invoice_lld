class Notification::Email::EmailBuilder < ::NotificationBuilder
  attr_accessor :from, :cc, :bcc, :type, :body, :template

  def initialize(from = 'wecare@meesho.com', cc, bcc)
    # Init attributes
  end

  def set_recipient
  end
  # Override in concrete builder class
  def set_type
    @type = "email"
  end

  def set_template

  end

  def set_actual_body
    template.parse
  end

  def set_tracking
    puts "Tracking pixel appended in email body"
  end

  def no_dependency?
    return ::DependencyManager.has_dependency_locked?(nil, notification)
  end

  def get_notification
    puts "Email notification object ready to be relayed"
  end

  def relay
    # hard coding end point here
    Relay::Base.send(body, "any endpoint here")
  end

  def mark_enqueued
    "Mark enqueued"
  end


end