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
      let(:contributor) { article.contributors.select { |c| c.type == "editor" }.first }
      let(:editor) { article.editors.first }

      it "should have Alana L. Welm as the editor" do
        editor.to_s.should == "Alana L. Welm"
      end

      it "should be affiliated with edit1" do
        contributor.xrefs.size.should == 1
      end

      it "should be affiliated with edit1" do
        contributor.xrefs.first[:id].should == "edit1"
      end
    end

    it "should have 15 figures" do
      article.figures.size.should == 15
    end

    context "the first figure" do
      let(:figure) { article.figures.first }

      it "should have the proper id" do
        figure.id.should == "pone-0028384-g001"
      end

      it "should have the proper position" do
        figure.position.should == "float"
      end

      it "should have the proper label" do
        figure.label.should == "Figure 1"
      end

      it "should have the proper caption" do
        figure.caption.should == {:title=>"Expression of CDX-2 and CK-20 in the tumor tissues of lymphatic (A and B) and hepatic metastasis (C and D).", :body=>"Original magnifications, x200."}
      end

      it "should have the proper graphic" do
        figure.graphic.should == {:mimetype=>"image", :position=>"float", :link=>"info:doi/10.1371/journal.pone.0028384.g001"}
      end

      it "should have the proper object" do
        figure.object.should == {:type=>"doi", :value=>"10.1371/journal.pone.0028384.g001"}
      end
    end

    it "should have 44 references" do
      article.references.size.should == 44
    end

    context "the first reference" do
      let(:reference) { article.references.first }

      it "should have the proper id" do
        reference.id.should == "pone.0028384-Morton1"
      end

      it "should have the proper title" do
        reference.title.should == "Establishment of human tumor xenografts in immunodeficient mice."
      end

      it "should have the proper label" do
        reference.label.should == "1"
      end

      it "should have the proper type" do
        reference.type.should == "journal"
      end

      it "should have the proper authors" do
        reference.authors.size.should == 2
        reference.authors.first.to_s.should == "CL Morton"
        reference.authors.last.to_s.should == "PJ Houghton"
      end

      it "should have the proper year" do
        reference.year.should == "2007"
      end

      it "should have the proper source" do
        reference.source.should == "Nat Protoc"
      end

      it "should have the proper volume" do
        reference.volume.should == "2"
      end

      it "should have the proper first_page" do
        reference.first_page.should == "247"
      end

      it "should have the proper last_page" do
        reference.last_page.should == "250"
      end
    end

    it "should have 19 sections" do
      article.sections.size.should == 19
    end

    it "should have X named content items" do
      article.named_content.size.should == 12
    end

    context "the first named content item" do
      let(:item) { article.named_content.first }

      it "should be a gene" do
        item[:type].should == "gene"
      end

      it "should have the correct value" do
        item[:value].should == "5'- AGGACGCAAGGAGGGTTTG -3'"
      end
    end
  end
end
