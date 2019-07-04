class SearchesController < ApplicationController
  include SearchesHelper

  def show
    if params[:search_term].blank?
      render 'show'
    else
      search_query = params[:search_term].downcase
      get_artistInfo(search_query)
      if logged_in?
        user = User.find(session[:user_id])
        search_entry = user.searches.create({search_query: params[:search_term]})
      end
    end
  end
end
