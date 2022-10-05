describe ApiV0::Posts do
  let(:user) { create(:user) }
  let(:posts) { create_list(:post, 3, user: user) }
  let(:api_access_token) { create(:api_access_token, user: user) }
  let(:access_key) { api_access_token.key }
  let(:result) { JSON.parse(response.body) }

  context "GET /api/v0/posts" do
    subject { get "/api/v0/posts", params: { access_key: access_key } }

    it "return 200 ok" do
      subject

      expect(response.status).to eq(200)
    end

    it "return posts" do
      posts
      subject

      expect(result.map {|post| post["id"]}).to eq(posts.pluck(:id))
    end
  end

  context "Get /api/v0/posts/:id" do
    let(:post) { posts.sample }
    subject { get "/api/v0/posts/#{post.id}", params: { access_key: access_key } }

    it "return 200 ok to show post" do
      subject

      expect(response.status).to eq(200)
    end

    it "return a post by id" do
      subject

      expect(result["title"]).to eq(post.title)
    end
  end

  context "Post /api/v0/posts" do
    subject { post "/api/v0/posts", params: { access_key: access_key, user: user, title: "title", context: "context" } }

    it "retrun 201 to create a post" do
      subject

      expect(response.status).to eq(201)
    end

    it "create new post object" do
      subject

      expect(result["title"]).to eq("title")
      expect(result["context"]).to eq("context")
    end

    it "create new post" do
      expect { subject }.to change { user.posts.count }.by(1)
    end
  end

  context "Patch /api/v0/posts/:id" do
    let(:post) { posts.sample }
    subject { patch "/api/v0/posts/#{post.id}", params: { access_key: access_key, user: user, title: "new_title", context: "new_context" }}

    it "return 200 to update a post" do
      subject
      expect(response.status).to eq(200)
    end

    it "update a post" do
      subject

      expect{ post.reload }.to change { post.title }.from(post.title).to("new_title") &
                               change { post.context }.from(post.context).to("new_context")

      # post.reload

      # expect(result["title"]).to eq(post.title)
      # expect(result["context"]).to eq(post.context)
    end
  end

  context "Delete /api/v0/posts/:id" do
    let(:post) { posts.sample }
    subject { delete "/api/v0/posts/#{post.id}", params: { access_key: access_key } }

    it "return 200 to delete post" do
      subject
      expect(response.status).to eq(200)
    end

    it "delete a post" do
      subject

      expect(result["title"]).to eq(post.title)
      expect(result["context"]).to eq(post.context)
      expect{ post.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
