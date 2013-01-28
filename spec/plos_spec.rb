require 'plos'

describe PLOS do
  context "A client" do
    let(:client) { client = PLOS::Client.new("API_KEY") }

    it "should call the correct search url" do
      RestClient.should_receive(:post).with("http://api.plos.org/search", {:api_key=>"API_KEY", :q=>"xenograft", :rows=>50, :start=>0}).and_return("")
      client.search("xenograft")
    end

    it "should call the correct search url when rows and start are specified" do
      RestClient.should_receive(:post).with("http://api.plos.org/search", {:api_key=>"API_KEY", :q=>"xenograft", :rows=>100, :start=>200}).and_return("")
      client.search("xenograft", 100, 200)
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
        article.article_url.should == "http://www.plosone.org/article/fetchObjectAttachment.action?uri=info:doi/10.1371/journal.pone.0050494&representation=XML"
      end

      it "should have the proper pdf article url" do
        article.article_url("PDF").should == "http://www.plosone.org/article/fetchObjectAttachment.action?uri=info:doi/10.1371/journal.pone.0050494&representation=PDF"
      end

      it "should have the proper ris citation url" do
        article.ris_citation_url.should == "http://www.plosone.org/article/getRisCitation.action?articleURI=info:doi/10.1371/journal.pone.0050494"
      end

      it "should have the proper bib tex citation url" do
        article.bib_tex_citation_url.should == "http://www.plosone.org/article/getBibTexCitation.action?articleURI=info:doi/10.1371/journal.pone.0050494"
      end
    end
  end
end
