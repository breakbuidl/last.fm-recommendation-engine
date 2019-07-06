require "rails_helper"

RSpec.describe "User sign up", :type => :request do

  it "Sign up page is rendered again with error message when invalid credentials are entered" do
    get "/signup"
    expect(response).to render_template("users/new")

    post users_path, :params => { :user => {:name => "", :email => "anyemail@test.com", :password => "pass123",
                                          :password_confirmation => "pass124"} }

    expect(response).to render_template("users/new")
    expect(assigns(:user).errors).to_not be_empty
  end

  it "Creates an account and displays profile info when valid credentials are entered" do
    post users_path, :params => { :user => {:name => "John Doe", :email => "anyemail@test.com", :password => "pass123",
                                          :password_confirmation => "pass123"} }

   #tests for user.save already done - User.new - model validations
   expect(response).to redirect_to(assigns(:user))
   follow_redirect!

   expect(response).to render_template(:show)
   expect(flash[:success]).to be_present
  end
end
