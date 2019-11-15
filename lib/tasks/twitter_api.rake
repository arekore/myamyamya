namespace :twitter_api do
    desc "Get hashtag time line"
    task :get_tweet do
        CONSUMER_KEY = Rails.application.secrets.twitter_api_key
        SECRET_KEY = Rails.application.secrets.twitter_secret_key
        query = "#絵こころ" #検索文字列

        client = Twitter::REST::Client.new(
            consumer_key: CONSUMER_KEY,
            consumer_secret: SECRET_KEY,
        )

        since_id = nil
        result_tweets = client.search(
            query,
            count: 50,
            result_type: "recent",
            locale: "ja",
            exclude: "retweets",
            filter: "images"
        )
    end
end
