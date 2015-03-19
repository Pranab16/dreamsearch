ThinkingSphinx::Index.define :product, :with => :active_record do
  indexes name, :sortable => true
  indexes category.name, :as => :author, :sortable => true

  has :id, :category_id
end
