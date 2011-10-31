# coding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["Kotaro Oshio"].each do |alb|
  al = Album.find_or_create_by_title(alb)
  [
    ["光のつばさ", "CGDGCD"],
    ["彩音",  "CGDGCD"],
  ].each do |t|
    tune   = Tune.find_or_create_by_title(t[0])
    tuning = Tuning.find_or_create_by_name(t[1])
    tuning.capo ||= t[2] != nil ? t[2] : 0
    tuning.tunes << tune
    tuning.save

    recording = Recording.new
    tune.recordings << recording
    al.recordings << recording
    tune.save
  end
  al.save
end

=begin
第三の男  DGDGBE
禁じられた遊び  Standard
アイルランドの風  AAEGAD
木もれ陽  Standard (Capo 5f)
Dancin' コオロギ  Standard
戦場のメリークリスマス  DADGAC
カバティーナ  DGDGBD
ボレロ  CGCGBE
星砂  DADGAD
アトランティス大陸  GGDGGG
ちいさな輝き  Standard
=end
