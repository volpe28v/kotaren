# language: ja

フィーチャ: ユーザ一覧を表示する
  ユーザとして、他のユーザの情報を知りたい

  シナリオ: 楽曲一覧からユーザ一覧を表示する
    前提    ユーザ "volpe" が登録されている
    前提    ユーザ "volpe" の楽曲リストを表示している
    もし　  "AllUser" リンクをクリックする
    ならば　"ユーザ一覧画面" を表示すること

