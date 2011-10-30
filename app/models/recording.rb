class Recording < ActiveRecord::Base
  belongs_to :tune
  belongs_to :album
end
