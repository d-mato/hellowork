require 'nokogiri'

module Hellowork::Parser
  def parse_current_page(text)
    doc = Nokogiri.parse(text)
    btn = doc.at('[type="button"][tabindex="-1"][readonly="readonly"]')
    if btn
      btn[:value].match(/\d+/).to_s
    end
  end

  def parse_total_count(text)
    doc = Nokogiri.parse(text)
    m = doc.at('.number-link-top > p')&.text&.match(/\d+/)
    m.nil? ? nil : m.to_s
  end

  # @return [Array]
  def parse_jobs(text)
    jobs = []

    doc = Nokogiri.parse(text)
    table = doc.at('.d-sole table')
    return jobs unless table

    table.css('tr').each_with_index do |tr, index|
      next if index.zero? # ヘッダーを無視

      job = {}
      tr.search('td').each_with_index do |td, index|
        case index
        when 2 then job['求人番号'] = td.text.to_s.delete("\n").strip
        when 3 then job['職種'] = td.text.to_s.strip
        when 4 then job['雇用形態／賃金（税込）'] = td.text.to_s.strip
        when 5 then job['就業時間／休日／週休二日'] = td.text.to_s.strip
        when 6 then job['産業'] = td.text.to_s.strip
        when 7 then job['沿線／就業場所'] = td.text.to_s.strip
        when 8 then job['受理日'] = td.text.to_s.strip
        end
      end
      jobs << job if job.any?
    end

    jobs
  end

  def parse_job(text)
    doc = Nokogiri.parse(text)
    tables = doc.css('.d-table table')
    return nil if tables.empty?

    job = {}
    tables.each do |table|
      table.css('tr').each do |tr|
        job[tr.at('th').text.strip] = tr.at('td').text.strip
      end
    end

    job
  end
end
