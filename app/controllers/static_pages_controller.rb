class StaticPagesController < ApplicationController

  CONSUMER_KEY = Rails.application.secrets.twitter_api_key
  SECRET_KEY = Rails.application.secrets.twitter_secret_key

  def home
    @schedule = Movie.all
    @schedule.each do |item|
      item.created_at += 60*60*9
    end

    @mostView = MostViewMovie.all.order(:rank)
    @mostView.each do |item|
      item.created_at += 60*60*9
    end
  end

  def history
    @history = History.all.order(:date)
    #Rails.logger.debug(@history_data.inspect)
  end

  def illust
    @illust = ajax().to_a
  end

  def about
    client = Twitter::REST::Client.new(
        consumer_key: CONSUMER_KEY,
        consumer_secret: SECRET_KEY,
    )
    result = client.status(1161275305119690752, tweet_mode: "extended")
    @amamiya_all_url = result.media[0].media_url_https
    @amamiya_setting_url = result.media[1].media_url_https
  end

  def other
  end

  def special
  end

  def downloadpdf
    file_name = "test.pdf"
    filepath = Rails.root.join("public", file_name)
    stat = File::stat(filepath)
    send_file(filepath, :filename => file_name, :length => stat.size)
  end

  private
    def ajax
      query = "#絵こころ" #検索文字列

      sleep(1)
      client = Twitter::REST::Client.new(
          consumer_key: CONSUMER_KEY,
          consumer_secret: SECRET_KEY,
      )
      since_id = nil
      result = client.search(
          query,
          count: 50,
          result_type: "recent",
          locale: "ja",
          exclude: "retweets",
          filter: "images",
          filter: "safe",
          tweet_mode: "extended"
      )
      return result
    end

end
