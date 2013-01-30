module PLOS
  class Name
    attr_accessor :style
    attr_accessor :given_name
    attr_accessor :surname

    def initialize(node)
      self.style = node.attr("name-style").value if node.attr("name-style")
    end
  end
end
