require_relative "test_helper"
require_relative "../lib/user"

describe "User class" do
  describe "initialize" do
    before do
      @user_inst = User.new(
        name: "adastudent",
        slack_id: "ADASTUD",
        real_name: "Ada Student",
        status_text: "Busy Busy",
        status_emoji: "",
      )
    end
    it "is an instance of User" do
      expect(@user_inst).must_be_kind_of User
    end
  end
  # Any tests involving a User should use the username SlackBot

  describe "list_all" do
    it "creates an array of users" do
      VCR.use_cassette("list_users_endpoint") do
        users = User.list_all

        expect(users).wont_be :empty?
        expect(users).must_be_kind_of Array
        expect(users[0]).must_be_kind_of User
      end
    end

    describe "self.get" do
      it "gets a list of users from the api" do
        list = {}
        VCR.use_cassette("list_users_endpoint") do
          list = User.get("https://slack.com/api/users.list")
        end
        
        expect(list).must_be_kind_of HTTParty::Response
        expect(list["ok"]).must_equal true
      end

      it "raises an error when the api call fails" do
        VCR.use_cassette("list_users_endpoint") do
          expect {User.get("https://slack.com/api/bogus.call")}.must_raise SlackAPIError
        end
      end
    end
  end
end
