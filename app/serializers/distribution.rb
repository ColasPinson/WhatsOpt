# frozen_string_literal: true

class DistributionSerializer < ActiveModel::Serializer
  attributes :kind
  
  has_many :options
end
