module TagMergers
  class ClassBasedMerger
    def initialize(context)
      @context = context
    end

    def merge(text)
      match_data = /(?<klass>.+):\[(?<params>.*)\]/.match(text)
      klass_name = match_data[:klass].split(':').map(&:capitalize).join("::")
      params = match_data[:params].split(';').inject({}) do |res, el|
        unless el.blank?
          md = /\A\$(?<key>.+)=(?<value>.*)\z/.match(el)
          unless md[:key].blank?
            res[md[:key].to_sym] = md[:value]
          end
        end
        res
      end
      constantize(klass_name).send(:new, params)
    end

    private
    def constantize(klass_name)
      constant = Object
      klass_name.split('::').each do |name|
        args = Module.method(:const_get).arity == 1 ? [] : [false]
        constant = if constant.const_defined?(name, *args)
                     constant.const_get(name)
                   else
                     constant.const_missing(name)
                   end
      end
      constant
    end
  end
end
