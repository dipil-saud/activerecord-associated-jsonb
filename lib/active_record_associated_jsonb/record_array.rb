# frozen_string_literal: true

module ActiveRecordAssociatedJsonb
  class RecordArray
    extend Forwardable

    # delegate array methods to underlying collection so array actions can be performed
    def_delegators :@collection, *(Array.instance_methods - Object.instance_methods)
    def_delegator :@collection, :as_json

    # @param records [Array<Hash>] Hash of attributes
    # @param child_class [Class] The class of the record in the collection.
    #   Preferebly child class of JsonbEmbedded::Record
    def initialize(records, child_class)
      @collection = Array.wrap(records).map do |input|
        input.is_a?(child_class) ? input : child_class.new(input)
      end
    end

    # @return [Array]
    def to_a
      @collection
    end
  end
end
