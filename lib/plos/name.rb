module PLOS
  class Name
    include XmlHelpers

    attr_accessor :style
    attr_accessor :given_name
    attr_accessor :surname

    def initialize(node)
      self.style = node.attr("name-style") if node.attr("name-style")
      self.given_name = tag_value(node, "given-names")
      self.surname = tag_value(node, "surname")
    end

    def to_s
      "#{given_name} #{surname}"
    end
  end
end
