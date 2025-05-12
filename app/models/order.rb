class Order < ApplicationRecord
    serialize :products, Array
end
