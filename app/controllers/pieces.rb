class Object
  def to_query(key)
    require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
    "#{CGI.escape(key.to_param)}=#{CGI.escape(to_param.to_s)}"
  end
end

class Hash
  def to_query(namespace = nil)
    collect do |key, value|
      unless (value.is_a?(Hash) || value.is_a?(Array)) && value.empty?
        value.to_query(namespace ? "#{namespace}[#{key}]" : key)
      end
    end.compact.sort! * '&'
  end
end

class Array
  def to_query(key)
    prefix = "#{key}[]"

    if empty?
      nil.to_query(prefix)
    else
      collect { |value| value.to_query(prefix) }.join '&'
    end
  end
end
class CatalogueSearch
  def initialize(options={})
    @options = options
  end

  attr_accessor :options

  def page
    options.fetch('page', 1).to_i
  end

  def page_size
    options.fetch('page_size', 3).to_i
  end

end
require "addressable/template"

class PiecesController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/pieces'

  def index

    ap request.GET['catalogue_search']
    search = CatalogueSearch.new request.GET.fetch('catalogue_search', {})
    pieces = Catalogue.all search
    render :index, :locals => {:pieces => pieces}
  end

  def new
    render :new
  end

  def create
    form = create_form.to_hash
    validator = Piece::Create::Validator.new

    record = Piece::Record.create form
    piece = Piece.new record
    redirect show_path(piece)
  end

  def show(catalogue_number)
    id = catalogue_number[/\d+/]
    if record = Piece::Record[id]
      @piece = Piece.new(record)
      render :show
    else
      redirect index_path
    end
  end

  def edit(catalogue_number)
    id = catalogue_number[/\d+/]
    if record = Piece::Record[id]
      @piece = Piece.new(record)
      render :edit
    else
      redirect index_path
    end
  end

  def update(catalogue_number)
    id = catalogue_number[/\d+/]
    if record = Piece::Record[id]
      form = Piece::Update::Form.new request.POST['piece']
      record.update form.to_hash
      piece = Piece.new(record)
      redirect show_path(piece)
    else
      redirect index_path
    end
  end

  def destroy(catalogue_number)
    id = catalogue_number[/\d+/]
    Piece::Record[id].destroy
    redirect index_path
  end

  def show_path(piece)
    File.join(index_path, piece.catalogue_number.to_s)
  end

  def index_path
    File.join *request.breadcrumb[0...-1].map(&:path)
  end

  def create_form
    Piece::Create::Form.new request.POST['piece']
  end
end
