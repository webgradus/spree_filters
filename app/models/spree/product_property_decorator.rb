Spree::ProductProperty.class_eval do
  # find all property values for products of taxon
  # You can use it for building checkbox-based dynamic filters
  def self.values_to_filter(taxon,property)
      Spree::ProductProperty.find_by_sql("SELECT value FROM spree_product_properties INNER JOIN spree_products ON spree_products.id = spree_product_properties.product_id INNER JOIN spree_products_taxons ON spree_products_taxons.product_id = spree_products.id INNER JOIN spree_taxons ON spree_taxons.id = spree_products_taxons.taxon_id WHERE spree_taxons.id IN (#{taxon.self_and_descendants.map(&:id).join(',')})   AND (property_id=#{property.id} AND value is not null AND value not like '%xsd:string%') GROUP BY value ORDER BY value ASC")
  end
end
