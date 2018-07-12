module Notification
  class DependencyManager
    # Ideally for high scale system, keep them in memory with graph DS
    # Preprocess and cache a snapshot of topological sorting and access the same with no DB lookup
    # Can have multiple dependency as well, Handling single one as of now as per requirement
    # type : exists? : enqueue acting_notification if dependent_on exists?
    # type : not_exists? : enqueue acting_notification if dependent_on doesn't exist?

    # Can be extended to add priority as well to maintain like a -> b-> c

    DEPENDENCIES = {
     "invoice_created_notification" =>
      {
        :dependent_on => "order_placed_notification",
        :type => "exists"
      }
    }

    TYPES = {
      "exists" => true,
      "not_exists" => false
    }.freeze

    ###### Mysql sample schema

    # CREATE TABLE dependency (
    #   `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    #   depends varchar(255) not null,
    #   dependent_on  varchar(255) not null,
    #   depends_type enum('exists', 'not_exists') not null.
    #   status enum("active", "inactive") default 'active'
    # )ENGINE=innnodb;

    #Sample record in dependency table

    # id => 1, depends => "invoice_created_notification",
    # dependent_on => "order_placed_notification"
    # type => "exists"

    #Explanation: invoice_created_notification will be enqueued to queue only when order_placed_notification exists in db with status >= enqueued


    # Dependency check, acting like lock release check
    def self.has_dependency_locked?(conn_obj = nil, notification)
      # fetch dependency on parent entity type
      dependency = $mysql.query("select * from dependency where depends = ? and status = ?",
        "invoice_created_notification", "active"
        ).limit(1)
      dependency_obj =  dependency.fetch()
      if dependency_obj.present?
        return Notification::Base.check_existance(dependency_obj.dependent_on, TYPES[dependency_obj.type], notification )
      end
      return true
    end
  end
end