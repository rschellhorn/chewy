module Chewy
  class Query
    module Pagination
      module Kaminari
        extend ActiveSupport::Concern

        included do
          include ::Kaminari::PageScopeMethods

          delegate :default_per_page, :max_per_page, :max_pages, to: :_kaminari_config

          class_eval <<-METHOD, __FILE__, __LINE__ + 1
            def #{::Kaminari.config.page_method_name}(num = 1)
              limit(limit_value).offset(limit_value * ([num.to_i, 1].max - 1))
            end
          METHOD
        end

        def limit_value
          (criteria.request_options[:size].presence || default_per_page).to_i
        end

        def offset_value
          criteria.request_options[:from].to_i
        end

      private

        def _kaminari_config
          ::Kaminari.config
        end
      end
    end
  end
end

Chewy::Query::Pagination.send :include, Chewy::Query::Pagination::Kaminari
