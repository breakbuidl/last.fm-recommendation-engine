require "rails_helper"
RSpec.configure do |c|
  c.include SessionsHelper
end

RSpec.describe "User login", :type => :request do

  before(:all) do
    User.new(name: "John Doe", email: "john@example.com", password: "password",
                                        password_confirmation: "password").save
  end

  it "login page is rendered again with flash message when invalid credentials are entered" do
    get "/login"
    expect(response).to render_template("sessions/new")

    post "/login", :params => {:session => {:email => "john@example.com", :password => "invalidpassword"}}
    expect(response).to render_template("sessions/new")
    expect(flash[:danger]).to be_present

    get "/"
    expect(flash[:danger]).to_not be_present
  end

  it "User profile is rendered and login link is replaced by profile and logout link when valid credentials are entered " do
    post "/login", :params => {:session => {:email => "john@example.com", :password => "password"}}
    expect(logged_in?).to eq(true)
    expect(response).to redirect_to(assigns(:user))
    follow_redirect!
    expect(response).to render_template(:show)


  end
end
