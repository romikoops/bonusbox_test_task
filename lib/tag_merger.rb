class TagMerger
  def initialize(tag, context)
    @tag = tag
    @context = context
    @strategy = choose_strategy
  end

  def execute
    @strategy.new(@context).merge(@tag)
  end

  private
  def choose_strategy
    case @tag
      when /\:\[(?:\$.+\=.*)?\]\z/
        TagMergers::ClassBasedMerger
      when /\A\w+(?:\:\w+)+\z/
        if @context.instance_variables.include?("@#{@tag.downcase.split(':').first}".to_sym)
          TagMergers::InstanceVariableBasedMerger
        else
          TagMergers::DefaultMerger
        end
      else
        TagMergers::DefaultMerger
    end
  end
end