# frozen_string_literal: true

module ControllerMacros
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def it_should_authenticate_for_actions(*actions_and_methods)
      actions_and_methods.each do |action_and_method|
        it "#{action_and_method[0]} action should require authentication" do
          process action_and_method[0], method: action_and_method[1], params: { id: 1 }
          expect(response.status).to eq(401)
        end
      end
    end
  end

  def authenticate_with_token
    u = User.create!(email: "authorized-user@test.com", password: "password")
    u.api_keys.create! token: "secret"
    request.headers["Authorization"] = "Bearer secret"
  end
end
