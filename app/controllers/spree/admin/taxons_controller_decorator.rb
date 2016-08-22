Spree::Admin::TaxonsController.class_eval do

  def permitted_taxon_attributes
    super + [
      property_ids: []
    ]
  end


end
