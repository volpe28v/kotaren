class Recording < ActiveRecord::Base
  belongs_to :tune, :album
end
