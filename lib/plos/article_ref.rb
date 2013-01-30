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
      @article ||= PLOS::Article.new(article_xml)
    end

    def article_xml
      Nokogiri::XML(RestClient.get(article_url))
    end

    def citation(format="RIS")
      url = (format == "RIS" ? ris_citation_url : bib_tex_citation_url)
      RestClient.get(url)
    end

    def base_url
      "http://www.plosone.org"
    end

    def article_url(format="XML")
      # format = "XML|PDF"
      "#{base_url}/article/fetchObjectAttachment.action?uri=info:doi/#{id}&representation=#{format}"
    end
    
    def ris_citation_url
      "#{base_url}/article/getRisCitation.action?articleURI=info:doi/#{id}"
    end

    def bib_tex_citation_url
      "#{base_url}/article/getBibTexCitation.action?articleURI=info:doi/#{id}"
    end
  end
end
