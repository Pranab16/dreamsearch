class Product < ActiveRecord::Base
  self.table_name = "products"

  belongs_to :category

end
