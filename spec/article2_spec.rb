require 'plos'

describe PLOS do
  context "Article 2" do
    let(:article) { PLOS::Article.new("10.1371/journal.pmed.0040075", Nokogiri::XML(File.read("spec/article2.xml"))) }

    it "should have the proper article title" do
      article.article_title.should == "Clinical Xenotransplantation of Organs: Why Aren't We There Yet?"
    end

    it "should have the proper journal title" do
      article.journal_title.should == "PLoS Medicine"
    end

    it "should have the proper issn" do
      article.issns.should == {"ppub"=>"1549-1277", "epub"=>"1549-1676"}
    end

    it "should have no affiliations" do
      article.affiliations.should be_empty
    end

    it "should have a single contributors" do
      article.contributors.size.should == 1
    end

    it "should have a single authors" do
      article.authors.size.should == 1
    end

    it "should not have an editor" do
      article.editors.should be_empty
    end

    it "should have 1 figures" do
      article.figures.size.should == 1
    end

    it "should have 75 references" do
      article.references.size.should == 75
    end

    it "should have 17 sections" do
      article.sections.size.should == 17
    end

    it "should not have named content" do
      article.named_content.should be_empty
    end
  end
end
