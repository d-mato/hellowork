# Hellowork


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hellowork'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hellowork

## Usage

### Initializing

```ruby
scraper = Hellowork::Scraper.new
scraper.search_options = {
  todofuken: %w(13 14), # 東京, 神奈川
  freeWord: 'エンジニア',
  notFreeWord: 'PHP'
}
```

### Auto paging

```ruby
scraper.search(wait_time: 10) do |page|
  # `page` is a Hellowork::ListPage instance
  
  p page.current_page # => 1
  p page.total_count  # => 1234
  p page.jobs
  # => [{"求人番号"=>"01010-16935481",
  #      "職種"=>"システムエンジニア・プログラマ",
  #      "雇用形態／賃金（税込）"=>"正社員／143,400円～365,000円",
  #      "就業時間／休日／週休二日"=>"1）09:00～18:00／土日祝他／毎週",
  #      "産業"=>"情報通信業のうちソフトウェア業",
  #      "沿線／就業場所"=>"東京都中央区",
  #      "受理日"=>"平成30年4月24日"}]
end
```

### Manual paging

```ruby
page = scraper.search
p page.jobs

next_page = scraper.next_page
p next_page.jobs
```

