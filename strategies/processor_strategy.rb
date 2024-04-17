class ProcessorStrategy
  def process(data)
    raise NotImplementedError, "This method should be overridden by subclass"
  end
end