module Spree
  module Core
    module Search
      class FiltersBase
        attr_accessor :properties
        attr_accessor :current_user
        attr_accessor :current_currency

        def initialize(params)
          self.current_currency = Spree::Config[:currency]
          @properties = {}
          prepare(params)
        end

        def retrieve_products
          @products_scope = get_base_scope
          curr_page = page || 1

          @products = @products_scope.includes([:master => :prices])
          unless Spree::Config.show_products_without_price
            @products = @products.where("spree_prices.amount BETWEEN #{@properties[:min]} AND #{@properties[:max]} AND spree_prices.amount > 0").where("spree_prices.currency" => current_currency)
          end
          @products = @products.page(curr_page).per(per_page)
        end

        def method_missing(name)
          if @properties.has_key? name
            @properties[name]
          else
            super
          end
        end

        protected

        def get_base_scope
          #.where("spree_taxonomies.name = '#{Main_taxonomy}' ")
          #
          properties_scope = get_properties_scope().blank? ? '' : 'spree_products.id in (' + get_properties_scope() + ')'
          base_scope = Spree::Product.active.where(properties_scope)
          base_scope = base_scope.in_taxon(taxon) unless taxon.blank?
          base_scope = get_products_conditions_for(base_scope, keywords)
          base_scope = add_search_scopes(base_scope)
          base_scope
        end


        def get_properties_scope
          return '' if @properties[:property_ids].nil?
          inter_strings=[]
          @properties[:property_ids].each do |id|
            inter_strings<<Spree::Product.joins(:product_properties).select('spree_products.id').search(:product_properties_property_id_eq => id.first).result.where("#{id.second.values.map{|e| "lower(spree_product_properties.value) LIKE lower('#{e}')"}.join(' OR ')}").to_sql
          end
          inter_strings.join(" INTERSECT ")
        end

        def add_search_scopes(base_scope)
          search.each do |name, scope_attribute|
            scope_name = name.to_sym
            if base_scope.respond_to?(:search_scopes) && base_scope.search_scopes.include?(scope_name.to_sym)
              base_scope = base_scope.send(scope_name, *scope_attribute)
            else
              base_scope = base_scope.merge(Spree::Product.ransack({scope_name => scope_attribute}).result)
            end
          end if search.is_a?(Hash)
          base_scope
        end

          # method should return new scope based on base_scope
          def get_products_conditions_for(base_scope, query)
            unless query.blank?
              base_scope = base_scope.like_any([:name, :description], query.split)
            end
            base_scope
          end

          def prepare(params)
            unless params[:property_ids].nil?
              @properties[:property_ids]=params[:property_ids] unless params[:property_ids].empty?
            end

            @properties[:min]= params[:min_price].to_i > 10_000_000 || params[:min_price].to_i <= 0 ? 0 : params[:min_price].to_i
            @properties[:max]= params[:max_price].to_i > 10_000_000 || params[:max_price].to_i <= 0 ? 10_000_000 : params[:max_price].to_i
            @properties[:taxon] = params[:taxon].blank? ? nil : Spree::Taxon.find(params[:taxon])

            @properties[:keywords] = params[:keywords]
            @properties[:search] = params[:search]

            per_page = params[:per_page].to_i
            @properties[:per_page] = per_page > 0 ? per_page : Spree::Config[:products_per_page]
            @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
          end
      end
    end
  end
end
