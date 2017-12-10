# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:hardwares) do
      set_column_type :price, :Bignum
    end
  end
end
