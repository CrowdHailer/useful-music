class ItemsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/items'

  def new
    check_access!
    piece_id = request.GET.fetch('piece_id')
    piece = Catalogue[piece_id]
    if piece
      @piece = Piece.new piece
      render :new
    else
      redirect '/pieces'
    end
  end

  def create
    check_access!
    form = Item::Create::Form.new request.POST['item']
    item = Item.create form
    redirect "/pieces/UD#{item.piece.id}/edit"
  end

  def edit(id)
    check_access!
    @item = Item.new(Item::Record[id])
    render :edit
  end

  def update(id)
    check_access!
    item_record = Item::Record[id]
    item_record.update request.POST['item']
    redirect "/pieces/UD#{item_record.piece_record.id}/edit"
  end

  def destroy(id)
    check_access!
    item = Item::Record[id]
    item.destroy
    redirect "/pieces/UD#{item.piece_record.id}/edit"
  end

  def check_access!
    if current_customer.admin?
      true
    else
      flash['error'] = 'Access denied'
      redirect '/'
    end
  end
end
