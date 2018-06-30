class Base
  attr_accessor :body, :tokens

  DEFAULT = "Hi {{username}}, Meesho !! This is default sms template"
  TOKENS = [
    :username
  ]
  def initialize(body, tokens)
    @body = body
    @tokens = tokens
  end

  def self.templates(notification_obj)
    templates = []
    all_templates =  notification_obj.templates || []
    all_templates.each do |template|
      templates << self.new(DEFAULT, TOKENS)
    end
    return templates
  end

  def parse
    # Simple parser , regex match and replace with tokens
    # Use moustache, liquid_template like templating engine
    self.body.gsub(/{{(.*?)}}/, tokens[:username])
  end
end