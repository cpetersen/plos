require 'plos'

describe PLOS do
  context "A single document" do
    it "should parse an ArticleRef" do
      xml =<<END 
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
      client = PLOS::Client.new("API_KEY")
      article = PLOS::ArticleRef.new(client, Nokogiri::XML(xml).root)
      article.type.should == "Research Article"
    end
  end
end
