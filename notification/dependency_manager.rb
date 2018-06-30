module Notification
  class DependencyManager
    # Ideally for high scale system, keep them in memory with graph DS
    # Preprocess and cache a snapshot of topological sorting and access the same with no DB lookup
    # Can have multiple dependency as well, Handling single one as of now as per requirement
    # type : exists? : enqueue acting_notification if dependent_on exists?
    # type : not_exists? : enqueue acting_notification if dependent_on doesn't exist?

    # Can be extended to add priority as well to maintain likea -> b-> c

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


    # Dependency check, acting like lock release check
    def self.has_dependency_locked?(conn_obj = nil, notification)
      dependency_obj = DEPENDENCIES[notification.name]
      if dependency_obj.present?
        return Notification::Base.check_existance(dependency_obj.dependent_on, TYPES[dependency_obj.type] )
      end
      return true
    end
  end
end