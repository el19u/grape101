describe ApiV0::Posts do
  let(:user) { create(:user) }
  let(:posts) { create_list(:post, 3, user: user) }
  let(:api_access_token) { create(:api_access_token, user: user) }
  let(:access_key) { api_access_token.key }
  let(:result) { JSON.parse(response.body) }
  
  context "GET /api/v0/posts" do
    it "return 200 ok" do
      get '/api/v0/posts', params: { access_key: access_key }

      expect(response.status).to eq(200)
    end

    it "return posts" do
      get "/api/v0/posts", params: { access_key: access_key }

      expect(result.map { |post| post["id"] }).to eq(posts.pluck(:id))
    end
  end

  context "Get /api/v0/posts/:id" do
    it "return a post by id" do
      post = posts.sample
      post = create(:post, user: user)

      get "/api/v0/posts/#{post.id}", params: { access_key: access_key }

      expect(response.status).to eq(200)
      expect(result["title"]).to eq(post.title)
    end
  end

  context "Post /api/v0/posts" do
    it "create new post" do
      title = "title"
      context = "context"
      post "/api/v0/posts", params: { access_key: access_key, user: user, title: title, context: context }

      expect(response.status).to eq(201)
      expect(result["title"]).to eq(title)
      expect(result["context"]).to eq(context)
    end
  end

  context "Patch /api/v0/posts/:id" do
    it "update a post" do
      post = posts.sample
      title = "updated title"
      context = "updated context"

      patch "/api/v0/posts/#{post.id}", params: { access_key: access_key, title: title, context: context }

      expect(response.status).to eq(200)
      expect(result["title"]).to eq(title)
      expect(result["context"]).to eq(context)
    end
  end

  context "Delete /api/v0/posts/:id" do
    it "delete a post" do
      post = posts.sample

      delete "/api/v0/posts/#{post.id}", params: { access_key: access_key }

      expect(response.status).to eq(200)
      expect(result["title"]).to eq(post.title)
      expect(result["context"]).to eq(post.context)
      expect{Post.find(post.id)}.to (raise_error ActiveRecord::RecordNotFound)
      expect(post.destroyed?) === true
    end
  end
end
