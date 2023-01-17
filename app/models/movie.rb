class Movie < ApplicationRecord
    validates :title, presence: true, uniqueness: true
    has_many :comments
end
