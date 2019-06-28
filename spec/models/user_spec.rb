require 'rails_helper'

RSpec.describe User, type: :model do

  describe "User attributes validations" do
    let!(:user) { User.new(name: "John Doe", email:"sample@example.com", password:"some_password",
                          password_confirmation:"some_password")}

    context "Presence Validations" do
      it "valid with valid attributes" do
        expect(user).to be_valid
      end

      it "not valid without name" do
        user.name = nil
        expect(user).to_not be_valid
      end

      it "not valid without email" do
        user.email = nil
        expect(user).to_not be_valid
      end

      it "not valid without password" do
        user.password = nil                    #Can do this. password/password_confirmation source code - setter/getter
        expect(user).to_not be_valid
      end

      it "not valid without password confirmation" do
        user.password_confirmation = nil                    #Can do this. password/password_confirmation source code - setter/getter
        expect(user).to_not be_valid
      end
    end

    context "Length Validations" do
      it "Name must be <= 50 chars" do
        user.name = "a" * 51
        expect(user).to_not be_valid
      end

      it "Password must be >= 6 chars" do
        user.password = user.password_confirmation = "a" * 5
        expect(user).to_not be_valid
      end
    end

    context "Email format" do
      it "Length must be <= 255 chars" do
        user.email = "a" * 244 + "@example.com"
        expect(user).to_not be_valid
      end

      it "Reject invalid addresses" do
        #this list is not exhaustive
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]

        invalid_addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user).to_not be_valid
        end
      end

      it "Should be unique case insensitive" do
        dup_user = user.clone
        dup_user.email = user.email.upcase
        user.save
        expect(dup_user).to_not be_valid
      end

      it "Should be saved as lower-case" do
        mixed_case_email = "Foo@Example.com"
        user.email = mixed_case_email
        user.save
        expect(user.reload.email).to eq(mixed_case_email.downcase)
      end
    end
  end
end
