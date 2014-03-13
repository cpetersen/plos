require 'plos'
require 'spec_helper'

describe PLOS do
  context "A client" do
    let(:client) { client = PLOS::Client.new("API_KEY") }

    it "should call the correct search url" do
      RestClient.should_receive(:post).with("http://api.plos.org/search", {:api_key=>"API_KEY", :q=>"xenograft", :rows=>50, :start=>0}).and_return("")
      client.search("xenograft")
    end

    it "should call the correct search url when rows and start are specified" do
      RestClient.should_receive(:post).with("http://api.plos.org/search", {:api_key=>"API_KEY", :q=>"xenograft", :rows=>100, :start=>200}).and_return("")
      client.search("xenograft", 200, 100)
    end

    it "should call the correct search url when finding all" do
      RestClient.should_receive(:post).with("http://api.plos.org/search", {:api_key=>"API_KEY", :q=>"*:*", :rows=>50, :start=>0}).and_return("")
      client.all
    end

    context "A single document" do
      let(:article) {
        xml =<<-END
          <doc>
            <float name="score">0.6637922</float>
            <str name="article_type">Research Article</str>
            <arr name="author_display">
              <str>Thomas D. Pfister</str>
              <str>Melinda Hollingshead</str>
              <str>Robert J. Kinders</str>
              <str>Yiping Zhang</str>
              <str>Yvonne A. Evrard</str>
              <str>Jiuping Ji</str>
              <str>Sonny A. Khin</str>
              <str>Suzanne Borgel</str>
              <str>Howard Stotler</str>
              <str>John Carter</str>
              <str>Raymond Divelbiss</str>
              <str>Shivaani Kummar</str>
              <str>Yves Pommier</str>
              <str>Ralph E. Parchment</str>
              <str>Joseph E. Tomaszewski</str>
              <str>James H. Doroshow</str>
            </arr>
            <arr name="abstract">
              <str>
                Lorem ipsum dolor sit amet
              </str>
            </arr>
            <str name="eissn">1932-6203</str>
            <str name="id">10.1371/journal.pone.0050494</str>
            <str name="journal">PLoS ONE</str>
            <date name="publication_date">2012-12-28T00:00:00Z</date>
            <str name="title_display">
            Development and Validation of an Immunoassay for Quantification of Topoisomerase I in Solid Tumor Tissues
            </str>
          </doc>
          END
          article = PLOS::ArticleRef.new(client, Nokogiri::XML(xml).root)
      }

      it "should parse an ArticleRef" do
        article.type.should == "Research Article"
      end

      it "should have the proper xml article url" do
        PLOS::Article.url(article.id).should == "http://www.plosone.org/article/fetchObjectAttachment.action?uri=info:doi/10.1371/journal.pone.0050494&representation=XML"
      end

      it "should have the proper pdf article url" do
        PLOS::Article.url(article.id, "PDF").should == "http://www.plosone.org/article/fetchObjectAttachment.action?uri=info:doi/10.1371/journal.pone.0050494&representation=PDF"
      end

      it "should have the proper ris citation url" do
        PLOS::Article.ris_citation_url(article.id).should == "http://www.plosone.org/article/getRisCitation.action?articleURI=info:doi/10.1371/journal.pone.0050494"
      end

      it "should have the proper bib tex citation url" do
        PLOS::Article.bib_tex_citation_url(article.id).should == "http://www.plosone.org/article/getBibTexCitation.action?articleURI=info:doi/10.1371/journal.pone.0050494"
      end
    end
  end
end
