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

  def is_sample_user(user)
    user.email == "sample@sample.kotaren"
  end

  def vrp_player_show(text)
    vrp_player_parse(text){ |id|
      vrp_player_html(id)
    }
  end

  def vrp_player_parse(text)
    raw(text.sub(/vrp:(\w+)/, yield('\1')))
  end

  def vrp_player_html(id)
    url = get_vrp_url(id)
    raw(
      '<iframe class="vrp" scrolling="yes" src="' + url + '#player"></iframe>' +
      '<br>' + vrp_player_link(id)
       )
  end

  def vrp_player_only_link(text)
    vrp_player_parse(text){ |id|
      vrp_player_link(id)
    }
  end

  def vrp_player_link(id)
    url = get_vrp_url(id)
    raw(
      '<a class="btn btn-mini" href="' + url + '">URL for VR+</a>'
       )
  end

  def get_vrp_url(id)
    return "" if id == nil
    'https://vr.shapeservices.com/play.php?hash=' + id
  end

end
