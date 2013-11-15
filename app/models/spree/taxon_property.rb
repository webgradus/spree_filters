module Spree
  class TaxonProperty < ActiveRecord::Base
    belongs_to :taxon
    belongs_to :property

    validates :property, presence: true
  end
end
