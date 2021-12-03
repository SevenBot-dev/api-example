import requests
import sys
import time

USER_ID = 00000000000000000
TOKEN = "ThisIsT0ken"

print("通信中...")


def delete_afk():
    response = requests.delete("https://api.sevenbot.jp/afk", headers={"Authorization": f"{USER_ID} {TOKEN}"})
    if response.status_code == 401:
        sys.stderr.write("認証に失敗しました。\n")
        sys.exit(1)
    elif response.status_code == 429:
        print("レートリミットに到達しました、やり直しています。")
        time.sleep(response.headers["Ratelimit-Reset"])
        delete_afk()
    else:
        response_data = response.json()
        if response_data["code"] == "not_afk":
            print("AFK状態ではありません。")
            sys.exit(0)
        print("AFKを解除しました。")
        print("メンションされたメッセージのURL：")
        if not response_data["urls"]:
            print("  (なし)")
        else:
            for url in response_data["urls"]:
                print(f"- {url}")
        if response_data["tweet"] is not None:
            print("ツイートされたメッセージのURL：")
            if response_data["tweet"] is False:
                print("  (失敗)")
            else:
                print(f"- {response_data['tweet']}")
        return


delete_afk()
