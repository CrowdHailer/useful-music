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
    item = Item.create form.to_hash
    redirect "/pieces/UD#{form.piece.id}/edit"
  end

  def edit(id)
    @item = Item.new(Item::Record[id])
    render :edit
  end

  def update(id)
    item_record = Item::Record[id]
    item_record.update request.POST['item']
    redirect "/pieces/UD#{item_record.piece_record.id}/edit"
  end

  def destroy(id)
    item = Item::Record[id]
    item.destroy
    redirect "/pieces/UD#{item.piece_record.id}/edit"
  end
end
