class Notification::Base
  attr_accessor :name, :payload, :primary_entity_type, :primary_entity_id

  # Constructor for a notifciation request object
  def initialize(name, payload)
    @name = name # notification name : order_placed, invoice_created etc
    @payload = payload # Json payload converted to hash object for manipulation
    # payload contains id, basic details of primary entity object like order amount, placed_at time etc
    @primary_entity_type = payload[:primary_entity_type] # Order/Invoice
    @primary_entity_id = payload[:primary_entity_id] # Order Id/Invoice id
  end

  def self.templates
    puts "All templates of notification"
    return Template::Base.templates()
  end

  def self.check_existance(notification, exist_flag)
    # Check if notification already exists or not exists depending on exist_flag
    # w.r.t to notification primary entity type or primary_entity_id with status enqueued
    return true
  end


  def self.trigger
    template_objs = templates
    template_objs.each do |template|
      if template.type == "email"
        # Can use factory here
        builder = Email::EmailBuilder.new
        notification = NotificationDirector.create_notification(builder)
        if notification.no_dependency
          puts "Relaying notification through third party api call"
          notification.relay
          puts "Marking enqueued"
          notification.mark_enqueued
        else
          puts "There is dependency still not resolved !! Pushing back to queue"
        end
      end
    end
  end











end

