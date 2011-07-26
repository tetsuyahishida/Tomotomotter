class User < ActiveRecord::Base
  validates_uniqueness_of :uid, :scope => :provider

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
      user.screen_name = auth["user_info"]["nickname"]
      user.token = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end
  end
  def self.send_receipt_direct_message (uid)
    u = User.find_by_uid(uid)
    begin
      u.client.direct_message_create(uid, "@#{u.screen_name}宛にTomotomotterのメールがきました http://tomotomotter.pira.jp/")
    rescue Twitter::Forbidden
    end
  end
  def client
    return Twitter::Client.new(:oauth_token => self.token, :oauth_token_secret => self.secret)
  end
  def uid_to_screen_name (uid)
    c = client
    c.user(uid).screen_name
  end
  def follower_ids (uid = self.uid)
    c = client
    ids = []
    ncursor = -1
    begin
      begin
        f = c.follower_ids(uid, :cursor => ncursor)
      rescue Twitter::Unauthorized
        self.destroy
      end
      if f
        ids += f.ids
        ncursor = f.next_cursor
      end
    end while ncursor > 0
    return ids
  end
  def followee_ids (uid = self.uid)
    c = client
    ids = []
    ncursor = -1
    begin
      begin
        f = c.friend_ids(uid, :cursor => ncursor)
      rescue Twitter::Unauthorized
        self.destroy
      end
      if f
        ids += f.ids
        ncursor = f.next_cursor
      end
    end while ncursor > 0
    return ids
  end
  def friend_ids (uid = self.uid)
    follower_ids(uid) & followee_ids(uid)
  end
  def common_friend_ids (uid1, uid2)
    u1 = User.find_by_uid(uid1)
    u2 = User.find_by_uid(uid2)
    common_follower_ids = u1.follower_ids & u2.follower_ids
    common_followee_ids = u1.followee_ids & u2.followee_ids
    common_follower_ids & common_followee_ids
  end
#  def tomotomo_ids (uid = self.uid)
#    fids = friend_ids(uid)
#    ffids = []
#    fids.each do |fid|
#      ffids2 = friend_ids(fid)
#      ffids += ffids2
#    end
#    (uniq! ffids) - fids
#  end
#  def send_direct_messages
#    follower_ids.each do |fid|
#      begin
#        client.direct_message_create(fid, "@#{self.screen_name}が，Tomotomotterで誰かと話しはじめました http://tomotomotter.pira.jp/")
#      rescue Twitter::Forbidden
#      end
#    end
#  end

  def self.egi_check
    User.order("created_at").each do |u|
      p u.screen_name
    end
    return
  end
  def self.egi_check2
    User.order("created_at").each do |u|
      p u.name
    end
    return
  end
end
