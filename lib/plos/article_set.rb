module PLOS
  class ArticleSet < Array
    attr_accessor :status
    attr_accessor :time
    attr_accessor :num_found
    attr_accessor :start
    attr_accessor :max_score
  end
end
