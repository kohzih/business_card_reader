class BusinessCard < ApplicationRecord
  has_one_attached :image

  validates :image, presence: true
  validate :image_format

  private

  def image_format
    return unless image.attached?

    unless image.blob.content_type.in?([ "image/jpeg", "image/jpg", "image/png" ])
      errors.add(:image, "はJPEGまたはPNG形式でアップロードしてください")
    end
  end
end
