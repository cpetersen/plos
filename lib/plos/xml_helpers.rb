require "nokogiri"

module PLOS
  module XmlHelpers
    def parse_node(node, obj=nil)
      value = case(node.name)
      when "arr"
        node.xpath('./*').collect { |child| parse_node(child) }
      when "date"
        DateTime.parse(node.content)
      when "float"
        node.content.to_f
      else
        node.content
      end
      if node.attr("name") && obj && obj.respond_to?(:"#{node.attr("name")}=")
        obj.send(:"#{node.attr("name")}=", value)
      end
      value
    end

    def tag_value(node,tag_name)
      child = node.search("#{tag_name}").first
      child.text if child
    end

    def nodes_to_hash(nodes, attribute_name)
      hash = {}
      nodes.each do |node|
        key = node.attr(attribute_name)
        value = node.text
        hash[key] = value
      end
      hash
    end
  end
end
