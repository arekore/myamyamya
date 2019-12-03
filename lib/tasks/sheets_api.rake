namespace :sheets_api do
    desc "API task for Google Sheets data"
    task :update => :environment do

        DEVELOPER_KEY = ENV["YOUTUBE_KEY"]
        
        spreadsheet_id = '1GokIVlJSLs8AjdhJ5P0xMt5o_6H-MAGY7Vj1ExpLlns'
        range = 'A2:E10000'

        service = Google::Apis::SheetsV4::SheetsService.new
        service.key = DEVELOPER_KEY
        response = service.get_spreadsheet_values(spreadsheet_id, range)

        unless response.values.empty?
            History.delete_all
            response.values.each do |item|
                history_data = History.new
                history_data.title = item[0]
                history_data.video_id = item[1]
                history_data.date = item[2]
                history_data.comment = item[3]
                history_data.flag = item[4]
                history_data.save
            end
        end
        #ログ
        Rails.logger.debug("Time : #{Time.now}, Schedule : #{response}")
    end
end
