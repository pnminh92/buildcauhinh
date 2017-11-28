# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:hardwares) do
      add_column :cloudinary_id, String, size: 127
      add_column :cloudinary_version, String, size: 31
      add_column :cloudinary_format, String, size: 15
    end
  end
end
