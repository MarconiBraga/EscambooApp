class Site::SearchController < SiteController

  def ads
    @ads = Ad.search(params[:term], params[:page])
    @categories = Category.all
  end
end
