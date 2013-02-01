module PLOS
  class Contributor
    include XmlHelpers

    attr_accessor :name
    attr_accessor :type
    attr_accessor :role
    attr_writer :xrefs

    def initialize(node)
      self.type = node.attr("contrib-type")
      self.name = PLOS::Name.new(node.search("name").first)
      self.role = tag_value(node, "role")
      node.search("xref").each do |xref|
        type = xref.attr("ref-type")
        id = xref.attr("rid")
        self.xrefs << { :type => type, :id => id }
      end
    end

    def xrefs
      @xrefs ||= []
    end
  end
end
