module ApplicationHelper
  def fb_like(url)
    raw ('<div class="fb-like" data-href="' + url + '" data-send="false" data-layout="button_count" data-width="150" data-show-faces="false" data-font="arial"></div>')
  end
end
