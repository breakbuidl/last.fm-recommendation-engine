require "rails_helper"

RSpec.describe "User sign up", :type => :request do

  it "Sign up page is rendered again with error message when invalid credentials are entered" do
    get "/signup"
    expect(response).to render_template("users/new")

    post "/users", :params => { :user => {:name => "", :email => "anyemail", :password => "pass",
                                          :password_confirmation => "pass1"} }

    expect(response).to render_template("users/new"), "Renders"
    expect(assigns(:user).errors).to_not be_empty
  end

  it "Creates an account and displays profile info when valid credentials are entered" do
    post "/users", :params => { :user => {:name => "John Doe", :email => "john@example.com", :password => "qwerty",
                                          :password_confirmation => "qwerty"} }

   #tests for user.save already done - User.new - model validations
   expect(response).to redirect_to(assigns(:user))
   follow_redirect!

   expect(response).to render_template(:show)
   expect(flash[:success]).to be_present
  end
end
