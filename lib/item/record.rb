require_relative './uploader/asset_uploader'

class Item
  class Record < Sequel::Model(:items)
    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.urlsafe_base64
    end
    many_to_one :piece_record, :class => :'Piece::Record', :key => :piece_id

    mount_uploader :asset, AssetUploader
  end
end
