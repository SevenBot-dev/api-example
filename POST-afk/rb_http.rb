require "http"

USER_ID = 00000000000000000
TOKEN = "ThisIsT0ken"

print "AFKにする理由を入力してください："
reason = gets.chomp

puts "通信中…"

def post_afk(reason)
  # @type [HTTP::Response]
  response = HTTP.post(
    "https://api.sevenbot.jp/afk",
    headers: {
      "Authorization": "#{USER_ID} #{TOKEN}",
    },
    json: {
      "reason": reason,
    },
  )
  case response.code
  when 401
    $stderr.puts "認証に失敗しました。"
  when 429
    puts "レートリミットに到達しました、やり直しています。"
    time.sleep(response.headers["Ratelimit-Reset"])
    post_afk(reason)
  else
    puts "AFKに設定しました。"
    json = response.parse
    unless json["tweet"].nil?
      tweet = json["tweet"]
      puts "ツイートされたメッセージのURL："
      if tweet == false
        puts "  (失敗)"
      else
        puts tweet
      end
    end
  end
end

post_afk(reason)
