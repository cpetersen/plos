require "rest_client"

module PLOS
  class Figure
    include XmlHelpers

    attr_accessor :id
    attr_accessor :position
    attr_accessor :label
    attr_writer   :caption
    attr_writer   :graphic
    attr_writer   :object

    def initialize(node)
      self.id = node.attr("id")
      self.position = node.attr("position")
      self.label = tag_value(node, "label")
      caption_node = node.search("caption").first
      if caption_node
        self.caption[:title] = tag_value(caption_node, "title")
        self.caption[:body] = tag_value(caption_node, "p")
      end

      graphic_node = node.search("graphic").first
      if graphic_node
        mimetype = graphic_node.attr("mimetype")
        position = graphic_node.attr("position")
        link = graphic_node.attr("xlink:href")
        self.graphic[:mimetype] = mimetype if mimetype
        self.graphic[:position] = position if position
        self.graphic[:link] = link if link
      end

      object_node = node.search("object-id").first
      if object_node
        type = object_node.attr("pub-id-type")
        value = object_node.text
        self.object[:type] = type if type
        self.object[:value] = value if value
      end
    end

    def caption
      @caption ||= {}
    end

    def graphic
      @graphic ||= {}
    end

    def object
      @object ||= {}
    end
  end
end
