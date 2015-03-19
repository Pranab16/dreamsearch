ThinkingSphinx::Index.define :category, :with => :active_record do
  indexes name, :sortable => true

  has :id, :as => :category_id, :type => :integer
end
