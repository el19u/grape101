describe ApiV0::Posts do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:api_access_token) { create(:api_access_token) }
  
  context "GET /api/v0/posts" do
    let(:accesskey_params) { { access_key: api_access_token.key, user: user } }
    let(:result) { JSON.parse(response.body) }

    it "return 200 ok" do
      get '/api/v0/posts', params: accesskey_params

      expect(response.status).to eq(200)
    end

    it "return posts" do
      get "/api/v0/posts", params: accesskey_params 

      expect(result.size).to eq(user.posts.size)
    end
  end
end