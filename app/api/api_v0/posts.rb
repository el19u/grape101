module ApiV0
  class Posts < Grape::API
    before { authenticate! }

    desc "Get all posts"
    get "/posts" do
      posts = current_user.posts

      present posts, with: ApiV0::Entities::Post
    end
  end
end