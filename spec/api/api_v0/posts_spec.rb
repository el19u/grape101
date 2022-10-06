describe ApiV0::Posts do
  let(:user) { create(:user) }
  let(:api_access_token) { create(:api_access_token, user: user) }
  let(:access_key) { api_access_token.key }
  let(:result) { JSON.parse(response.body) }

  context "GET /api/v0/posts" do
    let(:user_posts) { create_list(:post, 3, user: user) }
    subject { get "/api/v0/posts", params: { access_key: access_key } }

    it "return 200 ok" do
      subject

      expect(response.status).to eq(200)
    end

    it "return posts" do
      user_posts
      subject

      expect(result.map {|user_posts| user_posts["id"]}).to eq(user_posts.pluck(:id))
    end
  end

  context "Get /api/v0/posts/:id" do
    let(:user_post) { create(:post, user: user) }
    subject { get "/api/v0/posts/#{user_post.id}", params: { access_key: access_key } }
  
    it "return http code 200 ok" do
      subject
  
      expect(response.status).to eq(200)
    end
  
    it "return JSON of post data by id" do
      subject
  
      expect(result["id"]).to eq(user_post.id)
    end
  end
  
  context "Post /api/v0/posts" do
    subject { post "/api/v0/posts", params: { access_key: access_key, user: user, title: "title", context: "context" } }
  
    it "return http code 201" do
      subject
  
      expect(response.status).to eq(201)
    end
  
    it "return JSON of created post data" do
      subject
  
      expect(result["title"]).to eq("title")
      expect(result["context"]).to eq("context")
    end
  
    it "create new post" do
      expect { subject }.to change { user.posts.count }.by(1)
    end
  end
  
  context "Patch /api/v0/posts/:id" do
    let(:user_post) { create(:post, user: user) }
    subject { patch "/api/v0/posts/#{user_post.id}", params: { access_key: access_key, user: user, title: "new_title", context: "new_context" }}
  
    it "return 200 to update a post" do
      subject
      expect(response.status).to eq(200)
    end
  
    it "update a post" do
      subject
  
      expect{ user_post.reload }.to change { user_post.title }.from(user_post.title).to("new_title") &
                                    change { user_post.context }.from(user_post.context).to("new_context")
    end
  end
  
  context "Delete /api/v0/posts/:id" do
    let(:user_post) { create(:post, user: user) }
    subject { delete "/api/v0/posts/#{user_post.id}", params: { access_key: access_key } }
  
    it "return http code 200" do
      subject
      expect(response.status).to eq(200)
    end
  
    it "delete a post" do
      subject
  
      expect{ user_post.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
