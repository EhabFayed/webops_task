class MoveExistingPlogPhotos < ActiveRecord::Migration[8.0]
  def change
    Plog.find_each do |plog|
      attachment = ActiveStorage::Attachment.find_by(record_type: 'Plog', record_id: plog.id, name: 'photo_id')

      if attachment
        photo = PlogPhoto.new(
          plog_id: plog.id,
          alt_ar: plog.image_alt_text_ar,
          is_arabic: true
        )

        if photo.save(validate: false)
          attachment.update!(
            record_type: 'PlogPhoto',
            record_id: photo.id,
            name: 'photo'
          )
        else
          puts "Failed to migrate photo for Plog #{plog.id}: #{photo.errors.full_messages}"
        end
      end
    end
  end
end
