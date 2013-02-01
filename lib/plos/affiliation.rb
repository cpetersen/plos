module PLOS
  class Affiliation
    include XmlHelpers

    attr_accessor :id
    attr_accessor :label
    attr_accessor :address

    def initialize(node)
      self.id = node.attr("id")
      self.label = tag_value(node, "label")
      self.address = tag_value(node, "addr-line")
    end
  end
end
