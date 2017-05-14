require 'lib/base'

class Category < Base
  attr_accessor :label, :base_name

  def initialize(label: , base_name:)
    @label = label
    @base_name = base_name
  end
end
