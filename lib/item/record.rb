require_relative './uploader/asset_uploader'

class Item
  class Record < Sequel::Model(:items)
    many_to_one :piece_record, :class => Piece::Record, :key => :piece_id

    def piece=(piece)
      piece_record = piece
    end

    mount_uploader :asset, AssetUploader
  end
end
