module Spree
  BaseController.class_eval do
    def build_searcher params
      searcher_class = Spree::Core::Search::FiltersBase
      searcher_class.new(params).tap do |searcher|
        searcher.current_user = try_spree_current_user
        searcher.current_currency = current_currency
      end
    end
  end
end
