class Micropost < ApplicationRecord
  MICRO_PARAMS = %i(content image).freeze

  belongs_to :user

  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.mircropost.content_length}
  validates :image, content_type: {
    in: Settings.mircropost.img_type,
    message: I18n.t("microposts.invalid_format_text")
  },
                    size: {
                      less_than: Settings.mircropost.img_size.megabytes,
                      message: I18n.t("microposts.invalid_size_img_text")
                    }

  scope :order_post, ->{order created_at: :desc}
  scope :by_user_id, ->(user_id){where user_id: user_id}

  delegate :name, to: :user, prefix: true

  def display_image
    limit_display = Settings.mircropost.limit_display
    image.variant(resize_to_limit: [limit_display, limit_display])
  end
end
