require "rest_client"

module PLOS
  class ArticleRef
    attr_accessor :client
    attr_accessor :score
    attr_accessor :type
    attr_accessor :authors
    attr_accessor :eissn
    attr_accessor :id
    attr_accessor :journal
    attr_accessor :published_at
    attr_accessor :title
    alias :article_type= :type=
    alias :author_display= :authors=
    alias :title_display= :title=
    alias :publication_date= :published_at=

    def self.parse_node(node, obj=nil)
      value = case(node.name)
      when "arr"
        node.children.collect { |child| parse_node(child) }
      when "date"
        DateTime.parse(node.content)
      when "float"
        node.content.to_f
      else
        node.content
      end
      if node.attr("name") && obj
        obj.send("#{node.attr("name")}=",value)
      end
      value
    end

    def initialize(client, node)
      self.client = client
      node.children.each do |child|
        ArticleRef.parse_node(child, self)
      end
    end
  end
end
