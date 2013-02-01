require 'plos'

describe PLOS do
  context "Article 1" do
    let(:article) { PLOS::Article.new(Nokogiri::XML(File.read("spec/article1.xml"))) }

    it "should have the proper article title" do
      article.article_title.should == "Assessment of a Novel VEGF Targeted Agent Using Patient-Derived Tumor Tissue Xenograft Models of Colon Carcinoma with Lymphatic and Hepatic Metastases"
    end

    it "should have the proper journal title" do
      article.journal_title.should == "PLoS ONE"
    end

    it "should have the proper issn" do
      article.issns.should == { "epub" => "1932-6203" }
    end

    it "should have 5 affiliations" do
      article.affiliations.size.should == 5
    end

    context "the first affiliation" do
      let(:aff) { article.affiliations.first }

      it "should have the proper id" do
        aff.id.should == "aff1"
      end

      it "should have the proper label" do
        aff.label.should == "1"
      end

      it "should have the proper address" do
        aff.address.should == "Department of Surgical Oncology, First Affiliated Hospital, College of Medicine, Zhejiang University, Hangzhou, Zhejiang, China"
      end
    end

    it "should have 14 contributors" do
      article.contributors.size.should == 14
    end

    it "should have 13 authors" do
      article.authors.size.should == 13
    end

    context "the first author" do
      let(:author) { article.authors.first }

      it "should be Ketao Jin" do
        author.to_s.should == "Ketao Jin"
      end
    end

    context "the last author" do
      let(:author) { article.authors.last }

      it "should be Tieming Zhu" do
        author.to_s.should == "Tieming Zhu"
      end
    end

    it "should have 1 editor" do
      article.editors.size.should == 1
    end

    context "the editor" do
      let(:editor) { article.editors.first }

      it "should have Alana L. Welm as the editor" do
        editor.to_s.should == "Alana L. Welm"
      end
    end

    it "should have 44 references" do
      article.references.size.should == 44
    end

    it "should have 19 sections" do
      article.sections.size.should == 19
    end
  end
end
