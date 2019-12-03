namespace :youtube_api do
    desc "Update YouTube Schedule"
    task :scheduler => :environment do

        DEVELOPER_KEY = ENV["YOUTUBE_KEY"]
        CHANNELID = 'UCkIimWZ9gBJRamKF0rmPU8w' #天宮channelID

        def get_start(video_id)
          service = Google::Apis::YoutubeV3::YouTubeService.new
          service.key = DEVELOPER_KEY
          next_page_token = nil
          opt = {
              id: video_id
          }
          begin
              streaming = service.list_videos(:liveStreamingDetails, opt)
          rescue
              streaming = nil
          end
        end

        service = Google::Apis::YoutubeV3::YouTubeService.new
        service.key = DEVELOPER_KEY
        opt = {
          type: 'video',
          channel_id: CHANNELID,
          event_type: 'upcoming',
          max_results: 3,
          order: 'date'
        }
        begin
            schedule = service.list_searches(:snippet, opt)
        rescue
            schedule = nil
        end
        
        #DBに登録
        unless schedule.nil?
            Movie.delete_all
            schedule.items.each do |item|
                movie_insert = Movie.new
                movie_detail = item.snippet
                movie_insert.title = movie_detail.title
                movie_insert.status = movie_detail.live_broadcast_content
                movie_insert.thumbnail = movie_detail.thumbnails.medium.url
                movie_insert.video_id = item.id.video_id
                start_datetime = get_start(item.id.video_id).items[0].live_streaming_details.scheduled_start_time
                movie_insert.start_time = start_datetime.in_time_zone("UTC").in_time_zone("Tokyo") + 60*60*9
                movie_insert.save
            end
        end

        #配信中の情報取得（不要？）
        service = Google::Apis::YoutubeV3::YouTubeService.new
        service.key = DEVELOPER_KEY
        opt = {
          channel_id: CHANNELID,
          type: 'video',
          max_results: 1,
          event_type: 'live',
          order: 'date'
        }
        begin
            live_id = service.list_searches(:snippet, opt)
        rescue
            live_id = nil
        end

        unless live_id.nil?
            loop_count = 1
            live_id.items.each do |item|
                movie_insert = Movie.new
                movie_detail = item.snippet
                movie_insert.title = movie_detail.title
                movie_insert.status = movie_detail.live_broadcast_content
                movie_insert.thumbnail = movie_detail.thumbnails.medium.url
                movie_insert.video_id = item.id.video_id
                
                movie_insert.save
                loop_count += 1
            end
        end

        #ログ
        Rails.logger.debug("Time : #{Time.now}, Schedule : #{schedule}")
    end



    task :playlist => :environment do

        DEVELOPER_KEY = Rails.application.secrets.youtube_api_key
        CHANNELID = 'UCkIimWZ9gBJRamKF0rmPU8w' #天宮channelID
        def get_start(video_id)
          service = Google::Apis::YoutubeV3::YouTubeService.new
          service.key = DEVELOPER_KEY
          opt = {
              id: video_id
          }
          begin
              streaming = service.list_videos(:liveStreamingDetails, opt)
          rescue
              streaming = nil
          end
        end

        service = Google::Apis::YoutubeV3::YouTubeService.new
        service.key = DEVELOPER_KEY
        opt = {
          channel_id: CHANNELID,
          order: 'viewCount',
          type: 'video',
          max_results: 3
        }
        begin
            playlists = service.list_searches(:snippet, opt)
        rescue
            playlists = nil
        end
        
        #DBに登録
        unless playlists.nil?
            loop_count = 1
            MostViewMovie.delete_all
            playlists.items.each do |item|
                movie_insert = MostViewMovie.new
                movie_detail = item.snippet
                movie_insert.title = movie_detail.title
                movie_insert.rank = loop_count
                movie_insert.thumbnail = movie_detail.thumbnails.medium.url
                movie_insert.video_id = item.id.video_id
                start_datetime = get_start(item.id.video_id).items[0].live_streaming_details.actual_start_time
                movie_insert.start_date = start_datetime.in_time_zone("UTC").in_time_zone("Tokyo") + 60*60*9
                movie_insert.save
                loop_count += 1
            end
        end

        #ログ
        #Rails.logger.debug("Time : #{Time.now}, Schedule : #{schedule}")
    end

end
