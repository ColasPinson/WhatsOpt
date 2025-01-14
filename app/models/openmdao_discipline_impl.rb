# frozen_string_literal: true

class OpenmdaoDisciplineImpl < ActiveRecord::Base
  belongs_to :discipline

  after_initialize :_ensure_default_impl

  def build_copy
    OpenmdaoDisciplineImpl.new(
      implicit_component: implicit_component,
      support_derivatives: support_derivatives,
      egmdo_surrogate: egmdo_surrogate
    )
  end

  private
    def _ensure_default_impl
      self.implicit_component = false if implicit_component.nil?
      self.support_derivatives = false if support_derivatives.nil?
      self.egmdo_surrogate = false if egmdo_surrogate.nil?
    end
end
