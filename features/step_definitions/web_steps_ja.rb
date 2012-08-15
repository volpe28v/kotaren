# -*- encoding: UTF-8 -*-

もし /^　　トップページにアクセスする$/ do
  visit('/')
end

ならば /^　トップ画面を表示されていること$/ do
  page.should have_content("コタれんって")
end

前提 /^　　"([^"]*)" を表示している$/ do |page_name|
  case page_name
  when "トップページ"
    visit('/')
  when "新規登録画面"
    visit('/')
    click_on("新規登録して使ってみる")
  when "ログイン画面"
    visit('/')
#    find(".login-menu").click_on("ログイン")
    click_link("Login")
  else
    fail
  end
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

ならば /^　"([^"]*)" を表示すること$/ do |page_name|
  case page_name
  when "新規登録画面"
    page.should have_content("新規登録")
    page.should have_content("ログイン後にも変更可能です。")
  when "ログイン画面"
    find('legend').should have_content("ログイン")
    page.should have_css('#user_email')
    page.should have_css('#user_password')
  when "ランキング画面"
    page.should have_content("弾いている人数")
  when "ユーザ一覧画面"
    page.should have_content("Name")
    page.should have_content("Youtube")
    page.should have_content("LatestComment")
  when "アルバムリスト"
    #page.should have_content("Kotaro Oshio")
    page.should have_css('#album-list')
  else
    fail
  end
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

前提 /^ユーザ "([^"]*)" が登録されている$/ do |user_name|
  user = User.create(:name => user_name,
              :email => "#{user_name}@kotaren.com",
              :password => "#{user_name}#{user_name}",
              :password_confirmation => "#{user_name}#{user_name}")
  user.should_not be_nil
end

もし /^　  ユーザ "([^"]*)" のアカウント情報を入力する$/ do |user_name|
  fill_in("user_email", :with => "#{user_name}@kotaren.com")
  fill_in("user_password", :with => "#{user_name}#{user_name}")
end

もし /^　  "([^"]*)" リンクをクリックする$/ do |link_name|
  click_link(link_name)
end

もし /^　  "([^"]*)" のログインをクリックする$/ do |page_name|
  case page_name
  when "トップページ"
    find("#login").click
  when "ログイン画面"
    click_button("ログイン")
  else
    fail
  end
end

前提 /^ユーザ "([^"]*)" の楽曲リストを表示している$/ do |user_name|
  visit('/')
  fill_in("user_email", :with => "#{user_name}@kotaren.com")
  fill_in("user_password", :with => "#{user_name}#{user_name}")
  find("#login").click
end


