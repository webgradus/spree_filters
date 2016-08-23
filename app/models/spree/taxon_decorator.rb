Spree::Taxon.class_eval do
  has_many :taxon_properties
  has_many :properties, -> { order "spree_taxon_properties.created_at" }, :through => :taxon_properties

  def get_properties(name_cont)
    mas=[]
    if mas.empty?
      mas=Spree::Property.joins(products: :taxons).where("(spree_taxons.lft between #{self.lft} AND #{self.rgt} AND spree_taxons.rgt between #{self.lft} AND #{self.rgt}AND parent_id IS NOT NULL) AND presentation LIKE '%#{name_cont}%' ").uniq
    end
    return mas
  end

  def main_properties
    main_props = self.properties
    if main_props.empty? && self.parent_id
      main_props = self.parent.main_properties
    end
    main_props
  end

end
