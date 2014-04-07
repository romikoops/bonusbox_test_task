class Bonusbox::App
  attr_accessor :caption
  def initialize(params)
    @caption = params[:caption]
  end

  def to_s
    "[#{caption}](https://fb.bonusbox.me)"
  end
end
