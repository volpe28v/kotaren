class TuningsController < ApplicationController
  def load_tuning_list
    @user = User.find(params[:user_id])
    @tunings = Tuning.order("name ASC, capo ASC")

    lists = render_to_string :partial => 'tuning_list_body_smart_phone'
    render :json => { lists: lists },
           :callback => 'showTuningList'
  end
end
