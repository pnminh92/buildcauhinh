# frozen_string_literal: true

module Buildcauhinh
  module Concerns
    module CursorPagination
      PER_PAGE = 12

      def self.included(base)
        base.class_eval do
          dataset_module do
            def cursor(max_id = nil, per = nil)
              q = limit(per || PER_PAGE).order(Sequel.desc(:id))
              q = q.where(Sequel.lit('id < ?', max_id)) if max_id
              q
            end

            def next_info(max_id = nil)
              {
                has_next: where(Sequel.lit('id < ?', max_id)).first ? true : false,
                max_id: max_id
              }
            end
          end
        end
      end
    end
  end
end
