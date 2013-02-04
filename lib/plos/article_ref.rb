module PLOS
  class ArticleRef
    include PLOS::XmlHelpers

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

    def initialize(client, node)
      self.client = client
      node.children.each do |child|
        parse_node(child, self)
      end
    end

    def article
      @article ||= PLOS::Article.get(id)
    end

    def citation(format="RIS")
      url = (format == "RIS" ? PLOS::Article.ris_citation_url(id) : PLOS::Article.bib_tex_citation_url(id))
      RestClient.get(url)
    end
  end
end
