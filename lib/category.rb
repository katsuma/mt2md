require 'lib/base'

class Category < Base
  attr_accessor :label, :basename

  def initialize(label: , basement:)
    @label = label
    @basement = basement
  end
end
