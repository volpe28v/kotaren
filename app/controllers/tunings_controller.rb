class TuningsController < ApplicationController
  def load_tuning_list
    @tunings = Tuning.scoped.order("name ASC, capo ASC")

    lists = render_to_string :partial => 'tuning_list_body_smart_phone'
    render :json => { lists: lists },
           :callback => 'showTuningList'
  end
end
