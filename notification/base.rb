class Notification::Base
  attr_accessor :name, :payload, :primary_entity_type, :primary_entity_id


  $mysql = Mysql.new(host, "user123", "user123", "meesho")

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

  # Mysql schema sample for notification table

  #CREATE TABLE events (
  #   `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  #   event_name integer not null
  # )ENGINE=innodb;



  #CREATE TABLE notification (
  #   `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  #   event_id integer not null
  #   parent_type varchar(255) not null,
  #   parent_id integer not null,
  #   payload text not null,
  #   status enum("enqueued", "submitted", "failed", "delivered") not null
  # )ENGINE=innodb;

  #Sample values
  # id => 1, event_id = 1(invoice_created_notification), parent_type => "Invoice" (polymorphic class), parent_id => 12 (invoice id: polymorphic reference), payload => json payload ("amount" : 123.00, "currency" => "INR"),
  # status : enqueued




  def self.check_existance(dependent_on, exist_flag, notification)
    # Check if notification already exists or not exists depending on exist_flag
    # w.r.t to notification primary entity type or primary_entity_id with status enqueued
    if exist_flag

      # Checks if we have order placed notification sent (!failed) or not with that order_id (primary entity_id)
      # 2 event id for order_placed_notification
      # primary_entity_id for order_placed is order id
      exists = $mysql.query("select 1 from notification where event_id = ? and status != 'failed' and parent_type = ? and parent_id = ? ", 2, 'Order',notification.primary_entity_id).fetch
      return exists
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

