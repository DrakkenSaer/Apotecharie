module Spree
  class Headline < ActiveRecord::Base
    attr_accessible :title, :body, :poster, :deleted_at

    validates :title, presence: true, length: {minimum: 5, maximum: 100}
    validates :body, presence: true, length: {minimum: 5}

    # use deleted? rather than checking the attribute directly. this
    # allows extensions to override deleted? if they want to provide
    # their own definition.
    def deleted?
      !!deleted_at
    end

    def delete
      self.update_column(:deleted_at, Time.now)
    end
  end
end