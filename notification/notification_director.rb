module Notification
  class NotificationDirector

    # Director for builder class: using builder pattern for various notification
    # with different type and behaviour:
    def self.create_notification(notification_builder)
      notification_builder.set_recipient
      notification_builder.set_type
      notification_builder.set_body
      notification_builder.set_tracking
      return notification_builder.get_notification
    end

  end
end