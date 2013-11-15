class CreateSpreeTaxonProperties < ActiveRecord::Migration
  def change
    create_table :spree_taxon_properties do |t|
      t.references :taxon
      t.references :property

      t.timestamps
    end
  end
end
