class ItemsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/items'

  def new
    piece_id = request.GET.fetch('piece_id')
    piece_record = Piece::Record[piece_id]
    if piece_record
      @piece = Piece.new piece_record
      render :new
    else
      redirect '/pieces'
    end
  end

  def create
    form = Item::Create::Form.new request.POST['item']
    form.piece = Piece.new(Piece::Record[form.piece])
    item = Item.new
    form.to_hash.each do |key, value|
      item.send "#{key}=", value
    end
    item.record.save
    redirect "/pieces/UD#{form.piece.id}"
    # ap form.to_hash

    # Item::Record.create form.to_hash
  end
end
