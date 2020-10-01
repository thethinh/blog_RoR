# frozen_string_literal: true

class DownloadcsvsController < ApplicationController
  require 'zip'

  def info_csv
    start_date = 1.month.ago
    end_date = Time.zone.now

    # get current user's posts
    @posts = current_user.microposts.csv_post_1_month_recent(start_date, end_date)

    # get current user's followings
    @followings = current_user.following.csv_follow_1_month_recent(start_date, end_date)

    # get followers current user
    @followers = current_user.followers.csv_follow_1_month_recent(start_date, end_date)

    respond_to do |format|
      format.html
      format.zip do
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          zos.put_next_entry 'Posts.csv'
          zos.print @posts.to_csv_posts
          zos.put_next_entry 'Followings.csv'
          zos.print @followings.to_csv_follow
          zos.put_next_entry 'Followers.csv'
          zos.print @followers.to_csv_follow
        end
        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: 'Infor.zip'
      end
    end
  end
end
