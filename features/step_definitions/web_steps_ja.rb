# -*- encoding: UTF-8 -*-

もし /^　　トップページにアクセスする$/ do
  visit('/')
end

ならば /^　トップ画面を表示されていること$/ do
  page.should have_content("コタれんって")
end

前提 /^　　トップページを表示している$/ do
  visit('/')
end

前提 /^　　サンプルアカウントが存在する$/ do
  user = User.create(:name => "サンプルアカウント",
              :email => "sample@sample.kotaren",
              :password => "sample",
              :password_confirmation => "sample")
  user.should_not be_nil
end

もし /^　　サンプルアカウントでログインする$/ do
  #TODO: 本当は「サンプルアカウントでログイン」リンクを
  #      クリックしたいけど、link 内の onclick イベント
  #      が起動してくれないので、直接隠しボタンをクリッ
  #      クしている。
  #click_link "サンプルアカウントでログイン"
  find("#sample-login").click
end

ならば /^　サンプルアカウントの楽曲リストを表示すること$/ do
  page.should have_content("サンプルアカウント")
  page.should have_content("押尾コータロー楽曲リスト")
end

ならば /^　カレントユーザがサンプルアカウントであること$/ do
  page.should have_content("This is You!")
end

もし /^　  新規登録を選択する$/ do
  click_on("新規登録して使ってみる")
end

ならば /^　新規登録画面を表示すること$/ do
  page.should have_content("新規登録")
  page.should have_content("ログイン後にも変更可能です。")
end

前提 /^　　新規登録画面を表示している$/ do
  visit('/')
  click_on("新規登録して使ってみる")
end

もし /^　  ユーザ "([^"]*)" を登録する$/ do |user_name|
  fill_in("user_name", :with => user_name) 
  fill_in("user_email", :with => "#{user_name}@kotaren.com")
  fill_in("user_password", :with => "#{user_name}#{user_name}")
  fill_in("user_password_confirmation", :with => "#{user_name}#{user_name}")

  click_on("登録")
end

ならば /^　"([^"]*)" 楽曲リストを表示すること$/ do |user_name|
  page.should have_content(user_name)
  page.should have_content("押尾コータロー楽曲リスト")
end


