# coding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def regist_album(tune_info)
  al = Album.find_or_create_by_title(tune_info.shift)
  tune_info.each do |t|
    tune   = Tune.find_or_create_by_title(t[0])
    tuning = Tuning.find_or_create_by_name_and_capo( t[1], t[2] != nil ? t[2] : 0 )
    tuning.tunes << tune

    recording = Recording.find_or_create_by_tune_id_and_album_id( tune.id, al.id )
#    tune.recordings << recording
#    al.recordings << recording
#    recording.save
    tune.save
  end
end

regist_album([
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
])
