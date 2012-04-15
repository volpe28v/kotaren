module ApplicationHelper
  def fb_like(url)
    raw ('<div class="fb-like" data-href="' + url + '" data-send="false" data-layout="button_count" data-width="150" data-show-faces="false" data-font="arial"></div>')
  end

  def last_played_at(time)
    if time == '-'
      return raw('<span class="label">let\'s try to play this tune!</span>')
    end

    if time < 3.month.ago
      return raw('<span class="label label-important">last played at ' + time.strftime("%Y-%m-%d") + '</span>')
    elsif time < 1.month.ago
      return raw('<span class="label label-warning">last played at ' + time.strftime("%Y-%m-%d") + '</span>')
    end

    return raw('<span class="label label-success">last played at ' + time.strftime("%Y-%m-%d") + '</span>')

  end
end
