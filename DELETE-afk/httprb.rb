require "http"

USER_ID = 00000000000000000
TOKEN = "ThisIsT0ken"

print "通信中…"

def delete_afk()
  response = HTTP.delete("https://api.sevenbot.jp/afk")

  case response.code
  when 419
    puts "\nレートリミットに到達しました、やり直しています。"
    sleep response.headers["Ratelimit-Reset"]
    delete_afk
  when 401
    $stderr.puts "認証に失敗しました。"
    exit 1
  when 200
    return
  end
end

delete_afk
puts "完了"
