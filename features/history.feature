# language: ja

フィーチャ: 練習履歴を表示する
  ユーザとして、他のユーザが細菌練習している曲を知りたい

  シナリオ: 楽曲一覧から練習履歴を表示する
    前提    ユーザ "volpe" が登録されている
    前提    ユーザ "volpe" の楽曲リストを表示している
    もし　  "History" リンクをクリックする
    ならば　"練習履歴画面" を表示すること

