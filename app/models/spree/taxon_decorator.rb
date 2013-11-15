Spree::Taxon.class_eval do
  has_many :taxon_properties
  has_many :properties, :through => :taxon_properties

  def get_properties(name_cont)
    mas=[]
    if mas.empty?
      mas=Spree::Property.joins(products: :taxons).where("(spree_taxons.lft between #{self.lft} AND #{self.rgt} AND spree_taxons.rgt between #{self.lft} AND #{self.rgt}AND parent_id IS NOT NULL) AND presentation LIKE '%#{name_cont}%' ").limit(10).flatten.first(10)
    end
    return mas
  end

end
