Sequel.migration do
  up do
    create_table(:shopping_baskets) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:shopping_baskets)
  end
end
