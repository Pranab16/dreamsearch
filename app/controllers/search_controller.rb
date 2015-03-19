class SearchController < ApplicationController

  def index
    results_limit = 10
    @error=false
    # Get filtered query from key
    @key = params[:search]
    query = prepare_query_for_search(@key)
    page = params[:page] || 1

    options = {:match_mode=>:extended, :sort_mode=>:extended, :star=>true,
        :ignore_errors=>true, :populate=>true, :page=>page, :per_page=>results_limit, :retry_stale=>true}

    begin
     @results = ThinkingSphinx.search(query, options.merge(:classes => [Category, Product]))
    rescue
      @results = []
    end

  end

  def dropdown
    dropdown_results_limit = 3
    query = prepare_query_for_search(params[:key].to_s || '')
    options = {:match_mode=>:extended, :sort_mode=>:extended, :star=>true, :populate=>true, :page=>1,
        :per_page=>dropdown_results_limit, :retry_stale=>true}
    result = []
    category_ids = []

    products = Product.search(query, options.merge(:include => [:category]))

    products.each do |product|
      result << {:value=> product.name, :id => product.id, :category => product.category.name,
          :category_id => product.category_id}
      category_ids << product.category_id
    end

    categories = Category.search(query, options.merge(:without => {:category_id => category_ids}))
    categories.each{|category| result << {:value=>category.name, :id => category.id}}

    render :json=>result.to_json
  end

  private
  def prepare_query_for_search query
    query = Riddle::Query.escape(query).gsub("\\\"","\"")
    "(#{query.scan(/"[^"]*"|\S+/).join(") | (")})"
  end
end
