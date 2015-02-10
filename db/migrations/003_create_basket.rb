Sequel.migration do
  up do
    create_table(:shopping_baskets) do
      primary_key :id
    end
  end

  down do
    drop_table(:shopping_baskets)
  end
end
