import requests
import sys
import time

USER_ID = 00000000000000000
TOKEN = "ThisIsT0ken"

print("通信中...", end="")


def delete_afk():
    response = requests.delete("https://api.sevenbot.jp/afk", headers={"Authorization": f"{USER_ID} {TOKEN}"})
    if response.status_code == 401:
        sys.stderr.write("認証に失敗しました。\n")
        sys.exit(1)
    elif response.status_code == 419:
        print("\nレートリミットに到達しました、やり直しています。")
        time.sleep(response.headers["Ratelimit-Reset"])
        delete_afk()
    else:
        return


delete_afk()
print("完了")
