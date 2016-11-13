# coding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.find_or_create_by_email(:name => "サンプルアカウント",
                             :email => "sample@sample.kotaren",
                             :password => "sample",
                             :password_confirmation => "sample",
                             :guiter => "Martin D-28",
                             :tuning => "GGDGGD")
puts "registered sample account"
def register_album(tune_info)
  album_title = tune_info.shift
  al = Album.find_or_create_by_title(album_title)
  tune_info.each do |t|
    tune   = Tune.find_or_create_by_title(t[0])
    tuning = Tuning.find_or_create_by_name_and_capo( t[1], t[2] != nil ? t[2] : 0 )
    tuning.tunes << tune

    recording = Recording.find_or_create_by_tune_id_and_album_id( tune.id, al.id )
    tune.save
  end
  puts "registered album: #{album_title}"
end

register_album [
  "Kotaro Oshio",
  ["光のつばさ", "CGDGCD"],
  ["彩音",  "CGDGCD"],
  ["第三の男",  "DGDGBE"],
  ["禁じられた遊び",  "Standard"],
  ["アイルランドの風",  "AAEGAD"],
  ["木もれ陽",  "Standard", 5],
  ["Dancin' コオロギ",  "Standard"],
  ["戦場のメリークリスマス",  "DADGAC"],
  ["カバティーナ",  "DGDGBD"],
  ["ボレロ",  "CGCGBE"],
  ["星砂",  "DADGAD"],
  ["アトランティス大陸",  "GGDGGG"],
  ["ちいさな輝き",  "Standard"],
]

register_album [
  "LOVE STRINGS",
  ["Blue Sky",  "CGDGBD"],
  ["In the morning",  "Standard"],
  ["リボンの騎士",  "Standard"],
  ["ライムライト",  "Standard"],
  ["ピアノレッスン",  "CADGBE"],
  ["LOVE STRINGS",  "FCGDAE"],
  ["宵待月",  "Standard", 5],
  ["ニューシネマパラダイス",  "Standard"],
  ["遥かなる大地",  "EEBEF#B"],
  ["HARD RAIN",  "GGDGGD"],
  ["リベルタンゴ",  "Standard"],
  ["いつか王子様が",  "Standard"],
  ["ずっと… ",  "Standard"],
]

register_album [
  "STARTING POINT",
  ["Fantasy!",  "CGDGBD"],
  ["Destiny",  "Standard"],
  ["ティコ",  "Standard"],
  ["Breeze",  "Standard"],
  ["黄昏",  "Standard"],
  ["Merry Christmas Mr. Lawrence",  "DADGAC"],
  ["Blue sky (exciting version)",  "CGDGBD"],
  ["初恋",  "AEEF#BE"],
  ["Tension",  "CGDGB♭D"],
  ["ハリー・ライムのテーマ","DGDGBE"],
  ["木もれ陽 (cinema version)",  "Standard", 5],
  ["HARD RAIN (type:D)",  "GGDGGD"],
]

register_album [
  "DRAMATIC",
  ["SPLASH",  "DADGAD"],
  ["太陽のダンス",  "AEEF#BE"],
  ["風の詩",  "Standard"],
  ["ハッピー・アイランド",  "DADGBD"],
  ["カノン",  "DADGBD", 5],
  ["ボレロ",  "CGCGBE"],
  ["そらはキマグレ",  "DADF#AD"],
  ["約束",  "CGDGAD", 5],
  ["Chaser",  "CGCGB♭D"],
  ["プロローグ",  "Standard"],
  ["again...",  "Standard"],
]

register_album [
  "Be HAPPY",
  ["翼 ～you are the HERO～",  "DADGAD"],
  ["ミスティ・ナイト",  "EADGBD"],
  ["天使の日曜日",  "E♭B♭E♭A♭C♭E♭"],
  ["ジュピター",  "Standard"],
  ["Dear...",  "Standard"],
  ["AQUA-MARINE",  "CGDGBD"],
  ["見上げてごらん夜の星を",  "Standard"],
  ["ファイト！",  "BEADF#B"],
  ["Busy2",  "AAC#GBE"],
  ["桜・咲くころ",  "Standard"],
  ["坂の上の公園",  "Standard"],
]

register_album [
  "BOLERO! Be HAPPY LIVE",
  ["ボレロ",  "CGCGBE"],
  ["ブルー・ホール",  "CGDGBD"],
  ["AQUA-MARINE",  "CGDGBD"],
  ["Blue sky",  "CGDGBD"],
  ["ミスティ・ナイト",  "EADGBD"],
  ["Breeze",  "Standard"],
  ["Merry Christmas Mr. Lawrence",  "DADGAC"],
  ["オールド・フレンド",  "Standard"],
  ["Dear...",  "Standard"],
  ["見上げてごらん夜の星を",  "Standard"],
  ["Busy2",  "AAC#GBE"],
  ["HARD RAIN",  "GGDGGD"],
  ["翼 ～you are the HERO～",  "DADGAD"],
  ["ちいさな輝き",  "Standard"],
]

register_album [
  "Panorama",
  ["Departure",  "CGDGBD"],
  ["オアシス",  "AEEF#BE"],
  ["サバンナ",  "DADF#AD"],
  ["オーロラ",  "DADGAD"],
  ["コンドルは飛んで行く",  "CGDGBD"],
  ["Passion",  "Standard"],
  ["空色のみずうみ",  "Standard"],
  ["Friend",  "Standard" ,3],
  ["Brilliant Road",  "DAEAC#E"],
  ["家路",  "Standard"],
  ["Carnival",  "Standard"],
  ["夢のつづき",  "Standard"],
]

register_album [
  "Blue sky ~Kotaro Oshio Best Album~",
  ["Blue sky (exciting version)",  "CGDGBD"],
  ["HARD RAIN (type:D)",  "GGDGGD"],
  ["Fantasy!",  "CGDGBD"],
  ["桜・咲くころ",  "Standard"],
  ["SPLASH",  "DADGAD"],
  ["翼 ～you are the HERO～",  "DADGAD"],
  ["Departure",  "CGDGBD"],
  ["ハッピー・アイランド",  "DADGBD"],
  ["Chaser",  "CGCGB♭D"],
  ["ボレロ",  "CGCGBE"],
  ["カノン",  "DADGBD", 5],
  ["Merry Christmas Mr. Lawrence",  "DADGAC"],
  ["オアシス",  "AEEF#BE"],
  ["風の彼方（風の詩）",  "Standard"],
  ["ラスト・クリスマス",  "DADGBD"],
  ["Friend (CM version)",  "Standard" , 3],
]

register_album [
  "COLOR of LIFE",
  ["Big Blue Ocean",  "DADGAD"],
  ["YELLOW SUNSHINE",  "GGDGGD"],
  ["Indigo Love",  "Standard"],
  ["Red Shoes Dance",  "Standard"],
  ["クリスタル",  "CGDGBD"],
  ["グリーンスリーブス",  "Standard"],
  ["ブラックモンスター",  "DADGAC"],
  ["PINK CANDY",  "BBDG#BF#"],
  ["セピア色の写真",  "Standard"],
  ["星砂 ～金色に輝く砂浜～",  "DADGAD"],
  ["Purple Highway",  "CGDGB♭D"],
  ["あの夏の白い雲",  "DADGAD"],
]

register_album [
  "Nature Spirit",
  ["Deep Silence",  "AAEGAE"],
  ["Rushin'",  "AAEGAE"],
  ["DREAMING",  "Standard"],
  ["My Home Town",  "Standard"],
  ["TREASURE",  "DADGBD"],
  ["Buzzer Beater",  "DADGAD"],
  ["ノスタルジア",  "Standard"],
  ["渚",  "CGDGBD"],
  ["永遠の青い空",  "Standard"],
  ["Hangover",  "Standard"],
  ["IN MY LIFE",  "Standard"],
  ["PEACE!",  "DADGBD"],
  ["スマイル",  "Standard"],
  ["Christmas Rose",  "CGDGBD", 4],
]

register_album [
  "You & Me",
  ["Rushin'",  "AAEGAE"],
  ["Here We Go!",  "Standard"],
  ["君がくれた時間",  "Standard"],
  ["Big Blue Ocean",  "DADGAD"],
  ["あの夏の白い雲",  "DADGAD"],
  ["A Wonderful Day",  "Standard"],
  ["Purple Highway",  "CGDGB♭D"],
  ["HARD RAIN",  "GGDGGD"],
  ["ブラックモンスター",  "DADGAC"],
  ["With You",  "DADGAD"],
]

register_album [
  "Tussie mussie",
  ["LOVIN' YOU",  "Standard"],
  ["CLOSE TO YOU",  "C#G#D#G#B#D#"],
  ["そして僕は途方に暮れる",  "C#G#D#G#B#D#",3],
  ["元気を出して",  "Standard"],
  ["FIRST LOVE",  "CGDGBD"],
  ["CAN’T TAKE MY EYES OFF OF YOU ～君の瞳に恋してる～",  "Standard"],
  ["SOMEDAY",  "C#G#C#F#A#C#"],
  ["TIME AFTER TIME",  "C#G#D#G#B#D#", 3],
  ["涙のキッス",  "C#G#D#G#B#D#", 3],
  ["LOVE",  "Standard"],
]

register_album [
  "Eternal Chain",
  ["Prelude ～sunrise～",  "CGDGBD", 3],
  ["Landscape",  "CGDGBD", 3],
  ["Road Goes On",  "DADGAD"],
  ["Always",  "Standard"],
  ["Interlude ～forestbeat～",  "Standard"],
  ["Snappy!",  "AAEGAE"],
  ["旅の途中",  "C#G#EF#BE"],
  ["Interlude ～sunshine～",  "C#G#D#G#CD#"],
  ["楽園",  "C#G#D#G#CD#"],
  ["日曜日のビール",  "GCFB♭DG"],
  ["Believe",  "CGDGBD", 2],
  ["Interlude ～starlight～",  "C#G#EF#BE"],
  ["絆",  "C#G#EF#BE"],
  ["Earth Angel",  "AEEF#BE"],
  ["ハピネス",  "GCFB♭DG"],
  ["Coda ～sunset～",  "CGDGBD", 3],
]

register_album [
  "Hand to Hand",
  ["Brand New Wings",  "C#G#EF#BE"],
  ["HEART BEAT!",  "Standard"],
  ["Jet",  "GGDGAC"],
  ["ナユタ",  "C#G#D#G#CD#"],
  ["Good Times",  "CGDGBD"],
  ["もっと強く",  "BA♭D♭G♭B♭E♭"],
  ["予感",  "CGDGB♭D"],
  ["Little Prayer",  "GCFB♭DG"],
  ["Go Ahead",  "DADGAD"],
  ["雨上がり",  "E♭B♭E♭A♭B♭E♭"],
  ["手のひら",  "Standard"],
  ["草笛",  "DADF#BD"],
  ["Over Drive",  "AAEEAE"],
  ["fly to the dream",  "CGDGBD"],
  ["また明日。",  "Standard"],
]

register_album [
  "10th Anniversary BEST Upper Side",
  ["翼 〜Hoping for the FUTURE〜", "DADGAD"],
  ["HARD RAIN", "GGDGGD"],
  ["RELATION!", "DADF#AE"],
  ["Landscape",  "CGDGBD", 3],
  ["Over Drive",  "AAEEAE"],
  ["Fantasy!",  "CGDGBD"],
  ["Tension",  "CGDGB♭D"],
  ["PINK CANDY",  "BBDG#BF#"],
  ["太陽のダンス",  "AEEF#BE"],
  ["TREASURE",  "DADGBD"],
  ["Snappy!",  "AAEGAE"],
  ["HEART BEAT!",  "Standard"],
  ["Big Blue Ocean",  "DADGAD"],
  ["Jet",  "GGDGAC"],
  ["Rushin'",  "AAEGAE"],
  ["ファイト！",  "BEADF#B"],
]

register_album [
  "10th Anniversary BEST Ballade Side",
  ["MOTHER", "C#G#EF#BE"],
  ["黄昏",  "Standard"],
  ["Merry Christmas Mr. Lawrence",  "DADGAC"],
  ["ミスティ・ナイト",  "EADGBD"],
  ["天使の日曜日",  "E♭B♭E♭A♭C♭E♭"],
  ["ナユタ",  "C#G#D#G#CD#"],
  ["風の詩 〜10th Ver〜",  "DADGBE"],
  ["DREAMING",  "Standard"],
  ["オアシス",  "AEEF#BE"],
  ["桜・咲くころ",  "Standard"],
  ["日曜日のビール",  "GCFB♭DG"],
  ["木もれ陽",  "Standard", 5],
  ["Earth Angel",  "AEEF#BE"],
  ["ずっと… ",  "Standard"],
]

register_album [
  "Reboot & Collabo. Disc 1",
  ["Ready, Go!", "AAEGAE"],
  ["One Love, ～T's theme～", "DADGAD"],
  ["Weather Report", "DAEF#BE"],
  ["nanairo" ,"Standard"],
  ["Midnight Rain", "BBDF#BD"],
  ["MISSION", "CGE♭FB♭E♭"],
  ["キミノコト", "C#G#EF#BE"],
  ["STEALTH", "C#G#EF#BE"],
  ["Kiwi & Avocado", "Standard"],
]

register_album [
  "PANDORA",
  ["In the beginning", "CGDGB♭D"],
  ["彼方へ", "C#G#EF#BE"],
  ["いつか君と", "Standard"],
  ["誘惑", "CGDGB♭E♭", 2],
  ["月のナミダ", "DADF#BD"],
  ["亡き王女のためのパヴァーヌ", "AECF#BD"],
  ["恋の夢", "Standard"],
  ["キラキラ", "Standard", 5],
  ["Legend 〜時の英雄たち〜", "GGDGAD"],
  ["Marble", "Standard"],
  ["タイムカプセル", "CGDGBD"],
  ["星の贈り物", "CGDGBD"],
  ["NOW OR NEVER", "CGDGBD"],
  ["美しき人生", "Standard"],
]

register_album [
  "Tussie mussie II ~loves cinema~",
  ["Melody Fair", "CGDGBD", 3],
  ["Shape Of My Heart", "CGBGBD"],
  ["Mission Impossible Theme", "C#G#EF#BE"],
  ["The Never Ending Story", "CGDGBD"],
  ["風の谷のナウシカ", "FCGCEG"],
  ["Stand By Me", "CGDGBD"],
  ["The Last Emperor", "BEDGBE"],
  ["Calling You", "BF#DEAD"],
  ["Ben", "C#G#EF#BE"],
  ["The Godfather Medley", "CGDGB♭D"],
  ["Smile", "DADGBE"],
]

register_album [
  "KTRxGTR",
  ["Creativetime Ragtime","Standard"],
  ["Together!!!","AAEF#AE"],
  ["同級生 〜Innocent Days〜","Standard"],
  ["my best season","BEADF#B"],
  ["空と風のワルツ","Standard"],
  ["えんぴつと五線譜","Standard"],
  ["蜃気楼","CGDGB♭D"],
  ["茜色のブランコ","Standard"],
  ["Moment","AEEF#BE"],
  ["JOKER","BEADF#B"],
  ["勿忘草","Standard"],
  ["Birthday","C#G#EF#BE"],
  ["Plastic Love","Standard"],
  ["BE UP!","GGDGAD"],
  ["Magical Beautiful Seasons","Standard"],
  ["同級生 with Yuuki Ozaki","Standard"],
]

