class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size
  default_scope -> { order(created_at: :desc) }
  scope :calculation_oneweek, ->(start_date, end_date) { where(created_at: start_date..end_date) }
  scope :csv_post_1_month_recent, ->(start_date, end_date) {select(:created_at, :content, :picture).where(created_at: start_date..end_date)}

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  def self.to_csv_posts 

    # @picture = current_user.microposts.select(:picture)
    # convert to csv file
    attributes = %w{created_at content picture}

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
      
    end
  end
 
end
