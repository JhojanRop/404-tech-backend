class Producto < ApplicationRecord
    serialize :category, Array
    serialize :brand, Array
    serialize :image, Array
    serialize :tags, Array
end
