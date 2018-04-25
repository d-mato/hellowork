require 'hellowork/version'
require 'hellowork/list_page'
require 'hellowork/detail_page'

require 'mechanize'

module Hellowork
  class Scraper
    class PageError < StandardError; end
    attr_reader :search_options

    def search_options=(todofuken: [], freeWord: '', notFreeWord: '')
      @search_options = {
        todofuken: todofuken,
        freeWord: freeWord,
        notFreeWord: notFreeWord
      }
    end

    ## Usage:
    # scraper.search do |page|
    #   p page.current_page
    #   p page.jobs
    # end
    def search(wait_time: 10)
      @search_options ||= {}

      search_start_page_url = 'https://www.hellowork.go.jp/servicef/130020.do?action=initDisp&screenId=130020'
      agent.get search_start_page_url

      form = agent.page.form_with(id: 'ID_multiForm1')
      unless form
        raise PageError, 'Not found form. id: `ID_multiForm1`'
      end

      # 都道府県チェックボックス
      if @search_options[:todofuken].respond_to? :each
        @search_options[:todofuken].each do |pref_id|
          checkbox = form.checkbox_with(name: 'todofuken', value: pref_id)
          unless checkbox
            raise PageError, "Not found checkbox. name: `todouhuken`, value: `#{pref_id}`"
          end
          checkbox.check
        end
      end

      search_button = form.button_with(id: 'ID_commonSearch', value: '検索')
      unless search_button
        raise PageError, 'Not found button. id: `ID_commonSearch`, value: `検索`'
      end

      agent.click search_button

      form = agent.page.form_with(id: 'ID_mainForm')
      unless form
        raise PageError, 'Not found form. id: `ID_mainForm`'
      end

      # フリーワード
      %i(freeWord notFreeWord).each do |name|
        text_field = form.field_with(name: name.to_s)
        unless text_field
          raise PageError, "Not found field. name: `#{name}`"
        end
        text_field.value = @search_options[name].to_s
      end

      search_button = form.button_with(id: 'ID_commonSearch', value: '検索')
      unless search_button
        raise PageError, 'Not found button. id: `ID_commonSearch`, value: `検索`'
      end

      agent.click search_button
      page = ListPage.new(body: agent.page.body)

      if block_given?
        yield(page)
        loop do
          if next_page_button
            sleep wait_time
            yield(next_page)
          else
            break
          end
        end
      else
        page
      end
    end

    def next_page
      if next_page_button
        agent.click next_page_button
        ListPage.new(body: agent.page.body)
      end
    end

    def next?
      !!next_page_button
    end

    def fetch_detail(job_id)
      id1, id2 = job_id.split('-')
      url = "https://www.hellowork.go.jp/servicef/130050.do?screenId=130050&action=commonDetailInfo&kyujinNumber1=#{id1}&kyujinNumber2=#{id2}"
      page = Mechanize.new.get url
      DetailPage.new(body: page.body)
    end

    private

    def next_page_button
      form = agent.page.form_with(id: 'ID_mainForm')
      unless form
        raise PageError, 'Not found form. id: `ID_mainForm`'
      end
      form.button_with(name: 'fwListNaviBtnNext')
    end

    def agent
      @agent ||= Mechanize.new { |config|
        config.user_agent_alias = 'Windows Edge'
      }
    end
  end
end
