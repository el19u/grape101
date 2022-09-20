describe ApiV0::Posts do
  before(:all) do
    @user = create(:user)
    @posts = create_list(:post, 3, user: @user)
    @access_token = create(:api_access_token, user: @user)
  end

  context 'GET /api/v0/posts' do
    it 'should return 200 and posts' do
      get '/api/v0/posts', params: { access_key: @access_token.key }

      result = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(result.size).to eq(@user.posts.size)
    end
  end
end