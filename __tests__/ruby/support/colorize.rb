class String
  def colorize(*_args)
    self
  end

  %i[red yellow green blue cyan magenta white].each do |color_name|
    define_method(color_name) do
      self
    end
  end
end
