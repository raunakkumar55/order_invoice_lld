module Notification
  class NotificationBuilder

    def initialize
      raise "Abstract Class:: Subclass must override initialize"
    end
    # Override in concrete builder class. EmailBuilder/Smsbuilder
    def set_recipient
    end
    # Override in concrete builder class
    def set_type
    end
    # Override in concrete builder class
    def set_template
    end

    def set_actual_body
    end
    # Override in concrete builder class
    def set_tracking
    end

    def get_notification
    end

  end
end