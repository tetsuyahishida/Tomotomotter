class Bottle < ActiveRecord::Base
  has_many :bottle_users

  scope :recents, where("created_at > ?", Time.now - 1.day).order("created_at DESC")
  scope :inbox, lambda {|uid|
     where('last_flag = ? AND to_user = ?', true, uid).
     order("created_at DESC")
  }
  scope :sent, lambda {|uid|
     where('last_flag = ? AND from_user = ?', true, uid).
     order("created_at DESC")
  }
  scope :pool, where(:to_user => nil).order("created_at DESC")

  def self.reply_list(id)
    ret = []
    while id
      bottle = Bottle.find(id)
      ret << bottle
      id = bottle.prev_bottle
    end
    ret.reverse!
  end

  def self.egi_check
    Bottle.order("created_at").each do |b|
      p User.find_by_uid(b.from_user).screen_name
      p b.body
    end
    return
  end
end
