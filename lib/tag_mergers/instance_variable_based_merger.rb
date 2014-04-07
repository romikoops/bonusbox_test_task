module TagMergers
  class InstanceVariableBasedMerger
    def initialize(context)
      @context = context
    end

    def merge(text)
      text.downcase.split(':').inject(nil) do |res, el|
        if res.nil?
          @context.instance_variable_get("@#{el}")
        else
          if res.respond_to?(el)
            res.send el
          elsif res.class.respond_to?(el)
            res.class.send el
          else
            return text
          end
        end
      end
    end
  end
end