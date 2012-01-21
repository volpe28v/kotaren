class User < ActiveRecord::Base
  has_many :comments
  has_many :progresses

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :youtube_name, :twitter_name
  attr_accessible :guitar, :tuning

  validates :name,
    :presence => true,
    :uniqueness => true

  def default_name
    if self.name.blank?
      "NoName_#{self.id}"
    else
      self.name
    end
  end

  def youtube_url
    if self.youtube_name
      'http://www.youtube.com/user/' + self.youtube_name + '/videos'
    else
      '#'
    end
  end

  def twitter_url
    if self.twitter_name
      'https://twitter.com/#!/' + self.twitter_name
    else
      '#'
    end
  end


  def tunes_count(status,base_tunes = Tune)
    base_tunes.by_status_and_user(status,self).count
  end
end
