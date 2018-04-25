require 'hellowork/parser'

class Hellowork::DetailPage
  include Hellowork::Parser

  def initialize(body:)
    @body = body
  end

  def job
    @job ||= parse_job(@body)
  end

  # @override
  def inspect
    to_s
  end
end
