# frozen_string_literal: true
module ApiV0
  class Posts < Grape::API
    before { authenticate! }

    desc "Get all posts"
    get "/posts" do
      posts = current_user.posts

      present posts, with: ApiV0::Entities::Post
    end

    desc "Create a post"
    params do
      requires :title, type: String
      requires :context, type: String
    end
    post "/posts" do
      post = current_user.posts.new(declared(params, include_missing: false).except(:access_key))

      if post.save
        present post, with: ApiV0::Entities::Post
      else
        raise StandaraError, $!
      end
    end

    desc "Get a post"
    params do
      requires :id, type: Integer, desc: "Post ID."
    end

    get "/posts/:id" do
      post = current_user.posts.find(params[:id])

      present post, with: ApiV0::Entities::Post
    end

    desc "Update a post"
    params do
      requires :id, type: String, desc: "Post ID."
      requires :title, type: String, desc: "Post title."
      requires :context, type: String, desc: "Post context."
    end

    patch "/posts/:id" do
      post = current_user.posts.find(params[:id])

      if post.update(declared(params, include_missing: false).except(:access_key))
        present post, with: ApiV0::Entities::Post
      else
        raise StandaraError, $!
      end
    end

    desc "Delete a post"
    params do
      requires :id, type: String, desc: "Post ID"
    end
    delete "/posts/:id" do
      post = current_user.posts.find(params[:id])

      if post.destroy
        present post, with: ApiV0::Entities::Post
      else
        raise StandaraError, $!
      end
    end
  end
end
