require 'hellowork/parser'

class Hellowork::ListPage
  include Hellowork::Parser

  def initialize(body:)
    @body = body
  end

  def jobs
    @jobs ||= parse_jobs(@body)
  end

  def current_page
    @current_page ||= parse_current_page(@body).to_i
  end

  def total_count
    @total_count ||= parse_total_count(@body).to_i
  end

  # @override
  def inspect
    to_s
  end
end
