describe ApiV0::Posts do
  let(:user) { create(:user) }
  let(:article) { create(:post) }
  let(:api_access_token) { create(:api_access_token) }
  let(:access_key) { api_access_token.key }
  let(:result) { JSON.parse(response.body) }
  
  context "GET /api/v0/posts" do
    let(:access_key_params) { { access_key: access_key, user: user } }

    it "return 200 ok" do
      get '/api/v0/posts', params: access_key_params

      expect(response.status).to eq(200)
    end

    it "return posts" do
      get "/api/v0/posts", params: access_key_params 

      expect(result.size).to eq(user.posts.size)
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
end