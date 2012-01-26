# -*- encoding: UTF-8 -*-

もし /^　　トップページにアクセスする$/ do
  visit('/')
end

ならば /^　トップ画面を表示されていること$/ do
  page.should have_content("コタれんって")
end


