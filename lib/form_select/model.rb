# frozen_string_literal: true

module FormSelect
  module Model
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      # Use for define helper methods for Rails form.select tag
      #
      # for example:
      #
      #   class User < ApplicationRecord
      #     form_select :name, scope: -> { order("name asc") }
      #     form_select :email, text_method: :name, value_method: :email, scope: -> { where(status: :active).order("id desc") }
      #   end
      #
      #   <div class="field">
      #     <%= form.label :user_id %>
      #     <%= form.select :user_id, User.name_options %>
      #   </div>
      #   <div class="field">
      #     <%= form.label :email %>
      #     <%= form.select :email, User.email_options %>
      #   </div>
      #
      def form_select(method, text_method: nil, value_method: nil, scope: nil)
        method_name = "#{method}_options"

        text_method ||= method
        value_method ||= primary_key
        scope ||= -> { all }

        define_singleton_method(method_name) do
          scope.call.collect { |record| [record.send(text_method), record.send(value_method)] }
        end
      end
    end
  end
end