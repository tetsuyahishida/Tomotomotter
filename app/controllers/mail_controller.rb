# -*- coding: utf-8 -*-
class MailController < ApplicationController
  def about
    @user_count = User.count
    @bottle_count = Bottle.count
  end
  def index
    unless session[:user_id]
      redirect_to "/mail/about"
      return
    end
    @to_bottles = Bottle.inbox(current_user.uid)
  end
  def sent
    unless session[:user_id]
      redirect_to "/mail/about"
      return
    end
    @sent_bottles = Bottle.sent(current_user.uid)
  end
  def pool
    unless session[:user_id]
      redirect_to "/mail/about"
      return
    end
    @tomotomo_bottles = []
    fids = current_user.friend_ids
    Bottle.pool.each do |b|
      if b.last_flag # && (Time.now - User.find_by_uid(b.from_user).updated_at < 1.day)
        b_fids = b.bottle_users.map {|bu| bu.uid}
        if (fids & b_fids) != []
          unless current_user.uid == b.from_user || fids.index(b.from_user)
            @tomotomo_bottles << b
          end
        end
      end
    end
  end
  def show
    unless session[:user_id]
      redirect_to "/mail/about"
      return
    end
    @prev_id = params[:id]
    bottle = Bottle.find(@prev_id)
    @bottles = Bottle.reply_list(@prev_id)
    @common_friends = current_user.common_friend_ids(bottle.to_user, bottle.from_user).map {|uid| current_user.uid_to_screen_name(uid)}
  end
  def show_sent
    unless session[:user_id]
      redirect_to "/mail/about"
      return
    end
    @prev_id = params[:id]
    bottle = Bottle.find(@prev_id)
    @bottles = Bottle.reply_list(@prev_id)
    @common_friends = current_user.common_friend_ids(bottle.to_user, bottle.from_user).map {|uid| current_user.uid_to_screen_name(uid)}
  end
  def show_pool
    unless session[:user_id]
      redirect_to "/mail/about"
      return
    end
    @prev_id = params[:id]
    @bottle = Bottle.find(@prev_id)
    @common_friends = current_user.common_friend_ids(current_user.uid, @bottle.from_user).map {|uid| current_user.uid_to_screen_name(uid)}
  end
  def new
    unless session[:user_id]
      redirect_to "/mail/about"
      return
    end
    @bottle = Bottle.new
    @bottle.from_user = current_user.uid
    @bottle.to_user = nil
    @bottle.prev_bottle = nil
    @bottle.count = 0
  end
  def create
    bottle = Bottle.new(params[:bottle])
    fids = current_user.friend_ids
    bottle.save
    fids.each do |fid|
      bottle_user = BottleUser.new
      bottle_user.uid = fid
      bottle_user.bottle_id = bottle.id
      bottle_user.save
    end
    current_user.updated_at = Time.now
    current_user.save
    redirect_to(:controller => "mail", :action => "index", :notice => 'Bottle was successfully sent.')
  end
  def reply
    unless session[:user_id]
      redirect_to "/mail/about"
      return
    end
    prev = Bottle.find(params[:prev])
    @bottle = Bottle.new
    @bottle.from_user = current_user.uid
    @bottle.to_user = prev.from_user
    @bottle.prev_bottle = prev.id
    @bottle.count = prev.count + 1
  end
  def create_reply
    bottle = Bottle.new(params[:bottle])
    bottle.save
    prev_bottle = Bottle.find(bottle.prev_bottle)
    prev_bottle.last_flag = false
    prev_bottle.save
    current_user.updated_at = Time.now
    current_user.save
    User.send_receipt_direct_message(bottle.to_user)
    #if bottle.count == 1
    #  User.find_by_uid(bottle.to_user).send_direct_messages
    #  User.find_by_uid(bottle.from_user).send_direct_messages
    #  current_user.send_direct_messages
    #end
    redirect_to(:controller => "mail", :action => "index", :notice => 'Bottle was successfully sent.')
  end
end
