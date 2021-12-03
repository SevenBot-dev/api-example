require "http"
require "json"

USER_ID = 00000000000000000
TOKEN = "ThisIsT0ken"

puts "通信中…"

def delete_afk()
  # @type [HTTP::Response]
  response = HTTP.delete(
    "https://api.sevenbot.jp/afk",
    headers: {
      "Authorization" => "#{USER_ID} #{TOKEN}",
    },
  )

  case response.code
  when 429
    puts "レートリミットに到達しました、やり直しています。"
    sleep response.headers["Ratelimit-Reset"]
    delete_afk
  when 401
    $stderr.puts "認証に失敗しました。"
    exit 1
  else
    response_data = JSON.parse(response.body, symbolize_names: true)
    if response_data[:code] == "not_afk"
      puts "AFK状態ではありません。"
      exit 0
    end
    puts "AFKを解除しました。"
    puts "メンションされたメッセージのURL："
    if response_data[:urls].empty?
      puts "  (なし)"
    else
      response_data[:urls].each do |url|
        puts "- " + url
      end
    end
    unless response_data[:tweet].nil?
      puts "ツイートされたメッセージのURL："
      if response_data[:tweet] == false
        puts "  (失敗)"
      else
        puts "- " + response_data[:tweet]
      end
    end
    return
  end
end

delete_afk
