require "rest_client"

module PLOS
  class Section
    attr_accessor :id
    attr_accessor :title
    attr_accessor :type
    attr_writer :body
    attr_writer :sections

    def initialize(node)
      self.id = node.attr("id") if node.attr("id")
      self.type = node.attr("sec-type") if node.attr("sec-type")
      node.children.each do |child|
        case child.name
        when "title"
          self.title = child.text
        when "sec"
          self.sections << PLOS::Section.new(child)
        when "fig"
          self.sections << PLOS::Figure.new(child)
        else
          self.body << child.to_s
        end
      end
    end

    def body
      @body ||= ""
    end

    def sections
      @sections ||= []
    end
  end
end
