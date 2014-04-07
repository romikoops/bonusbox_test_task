class User
  attr_accessor :credit, :facebook, :badge
  def initialize
    @credit   = Credit.new
    @facebook = Facebook.new
    @badge    = Badge.new
  end

  def merge_tags(text)
    if text
      text.gsub(/%\{[^%{]+?\}/) do |match|
        tag = match.sub(/%\{(.*?)\}/, '\1')
        TagMerger.new(tag, self).execute
      end
    end
  end
end
