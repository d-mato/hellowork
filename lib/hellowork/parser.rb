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
        when 2 then job[:job_number] = td.text.to_s.delete("\n").strip
        when 3 then job[:job_category] = td.text.to_s.strip
        when 4 then job[:employment_status_and_wage] = td.text.to_s.strip
        when 5 then job[:working_hours_and_holiday_five_day_work_week] = td.text.to_s.strip
        when 6 then job[:industry] = td.text.to_s.strip
        when 7 then job[:work_place] = td.text.to_s.strip
        when 8 then job[:receipt_date] = td.text.to_s.strip
        end
      end
      jobs << job if job.any?
    end

    jobs
  end

  def parse_job(text)
    doc = Nokogiri.parse(text)

    {
      job_number: doc.at('.d-table table tr:nth-child(1) td').text.strip,
      information_type: doc.at('.d-table table tr:nth-child(2) td').text.strip,
      office_name: doc.at('.d-table table tr:nth-child(3) td').text.strip,
      representative_name: doc.at('.d-table table tr:nth-child(4) td').text.strip,
      corporate_number: doc.at('.d-table table tr:nth-child(5) td').text.strip,
      location: doc.at('.d-table table tr:nth-child(6) td').text.strip,
      phone: doc.at('.d-table table tr:nth-child(7) td').text.strip,
      fax: doc.at('.d-table table tr:nth-child(8) td').text.strip,
      business_description: doc.at('.d-table table tr:nth-child(9) td').text.strip,
      job_category: doc.at('.d-table table tr:nth-child(10) td').text.strip,
      employment_status: doc.at('.d-table table tr:nth-child(11) td').text.strip,
      industry: doc.at('.d-table table tr:nth-child(12) td').text.strip,
      working_type: doc.at('.d-table table tr:nth-child(13) td').text.strip,
      employment_period: doc.at('.d-table table tr:nth-child(14) td').text.strip,
      age: doc.at('.d-table table tr:nth-child(15) td').text.strip,
      age_restriction_reason: doc.at('.d-table table tr:nth-child(16) td').text.strip,
      working_hours: doc.at('.d-table table tr:nth-child(17) td').text.strip,
      break_time: doc.at('.d-table table tr:nth-child(18) td').text.strip,
      overtime_work: doc.at('.d-table table tr:nth-child(19) td').text.strip,
      weekly_working_days: doc.at('.d-table table tr:nth-child(20) td').text.strip,
      wage: doc.at('.d-table table tr:nth-child(21) td').text.strip,
      bonus: doc.at('.d-table table tr:nth-child(22) td').text.strip,
      holiday: doc.at('.d-table table tr:nth-child(23) td').text.strip,
      five_day_work_week: doc.at('.d-table table tr:nth-child(24) td').text.strip,
      annual_holidays: doc.at('.d-table table tr:nth-child(25) td').text.strip,
      childcare_leave: doc.at('.d-table table tr:nth-child(26) td').text.strip,
      nursery: doc.at('.d-table table tr:nth-child(27) td').text.strip,
      work_place: doc.at('.d-table table tr:nth-child(28) td').text.strip,
      relocation: doc.at('.d-table table tr:nth-child(29) td').text.strip,
      number_of_employees: doc.at('.d-table table tr:nth-child(30) td').text.strip,
      insurance: doc.at('.d-table table tr:nth-child(31) td').text.strip,
      retirement_age: doc.at('.d-table table tr:nth-child(31) td').text.strip,
      rehire: doc.at('.d-table table tr:nth-child(32) td').text.strip,
      company_house: doc.at('.d-table table tr:nth-child(33) td').text.strip,
      commuting_by_private_car: doc.at('.d-table table tr:nth-child(34) td').text.strip,
      commuting_allowance: doc.at('.d-table table tr:nth-child(35) td').text.strip,
      number_of_recruits: doc.at('.d-table table tr:nth-child(36) td').text.strip,
      job_description: doc.at('.d-table table tr:nth-child(37) td').text.strip,
      academic_background: doc.at('.d-table table tr:nth-child(37) td').text.strip,
      experience: doc.at('.d-table table tr:nth-child(38) td').text.strip,
      license: doc.at('.d-table table tr:nth-child(39) td').text.strip,
      selection_process: doc.at('.d-table table tr:nth-child(40) td').text.strip,
      selection_result_notification: doc.at('.d-table table tr:nth-child(41) td').text.strip,
      application_documents: doc.at('.d-table table tr:nth-child(42) td').text.strip,
      selection_date: doc.at('.d-table table tr:nth-child(43) td').text.strip,
      special_notes: doc.at('.d-table table tr:nth-child(44) td').text.strip,
      notes: doc.at('.d-table table tr:nth-child(45) td').text.strip,
      receipt_date: doc.at('.d-table table:nth-child(2) tr:nth-child(1) td').text.strip,
      expiration_date: doc.at('.d-table table:nth-child(2) tr:nth-child(2) td').text.strip,
      registration_office: doc.at('.d-table table:nth-child(2) tr:nth-child(3) td').text.strip,
    }
  end
end
