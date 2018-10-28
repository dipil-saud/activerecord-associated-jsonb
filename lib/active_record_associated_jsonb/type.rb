# frozen_string_literal: true

# This module uses the ActiveRecord attribute API to cast a jsonb array to an array of preferred objects
# Example Usage
# class ArModel < ApplicationRecord
#  attribute :jsonb_column, ActiveRecordAssociatedJsonb::Type.new(child_class: CustomClass)
# end
# The CustomClass can inherit from JsonbEmbedded::Record for extra features
module ActiveRecordAssociatedJsonb
  class Type < ActiveRecord::Type::Json
    # @param child_class: [Class] The child class in the Array
    def initialize(child_class:)
      @child_class = child_class
    end

    # @return [String]
    def type
      :jsonb_array
    end

    # @return [RecordArray]
    def cast(value)
      @child_class = @child_class.constantize if @child_class.is_a?(String)

      RecordArray.new(value, @child_class)
    end

    # @return [RecordArray]
    def deserialize(value)
      cast super(value)
    end

    # @return [Boolean] True if the value has been changed in the current active object
    def changed_in_place?(raw_old_value, new_value)
      serialize(deserialize(raw_old_value)) != serialize(new_value)
    end
  end
end
