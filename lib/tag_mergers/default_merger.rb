module TagMergers
  class DefaultMerger
    def initialize(context)
      @context = context
    end

    def merge(text)
      text
    end
  end
end