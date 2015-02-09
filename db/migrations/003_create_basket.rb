Sequel.migration do
  up do
    create_table(:baskets) do
      primary_key :id
    end
  end

  down do
    drop_table(:baskets)
  end
end
