module ApiV0
  class Posts < Grape::API
    before { authenticate! }

    desc "Get all posts"
    get "posts" do
      current_user.posts
    end
  end
end