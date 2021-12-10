import requests
import sys
import time

USER_ID = 00000000000000000
TOKEN = "ThisIsT0ken"

reason = input("AFKにする理由を入力してください: ")

print("通信中...")


def post_afk():
    response = requests.post(
        "https://api.sevenbot.jp/afk",
        headers={"Authorization": f"{USER_ID} {TOKEN}"},
        json={"reason": reason},
    )
    if response.status_code == 401:
        sys.stderr.write("認証に失敗しました。\n")
        sys.exit(1)
    elif response.status_code == 419:
        print("レートリミットに到達しました、やり直しています。")
        time.sleep(response.headers["Ratelimit-Reset"])
        post_afk()
    else:
        print("AFKに設定しました。")
        json = response.json()
        if tweet := json.get("tweet"):
            print("ツイートされたメッセージのURL：")
            if tweet is not None:
                print(tweet)
            else:
                print("  (失敗)")
        return


post_afk()
