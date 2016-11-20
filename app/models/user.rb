class User < ActiveRecord::Base
  has_many :comments
  has_many :progresses
  has_many :activities

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :youtube_name, :twitter_name, :icon_url
  attr_accessible :guitar, :tuning
  attr_accessible :notify, :all_notify

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

  def is_sample?
    self.email == "sample@sample.kotaren"
  end

  def add_activity
    activity = self.activities.find_or_create_by_date(Date.current)
    activity.count += 1
    activity.save
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.find_by_email(auth.info.email)

    unless user
      user = User.create(name:     auth.extra.raw_info.name,
                         email:    auth.info.email,
                         icon_url: auth.info.image,
                         password: Devise.friendly_token[0,20]
                        )
    else
      if user.icon_url.blank?
        user.update_attribute(:icon_url, auth.info.image)
      end
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.blacklist_keys
    super - %w(id)
  end
end
