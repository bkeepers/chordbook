require "test_helper"

class Api::LibraryControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
  end

  test "create unauthenticated" do
    post api_library_path
    assert_response :unauthorized
  end

  test "create with valid params" do
    songsheet = create(:songsheet)

    assert_difference -> { @user.songsheets.count } do
      post api_library_path, params: {uid: songsheet.uid},
        headers: token_headers(@user)
    end

    assert_response 201
  end

  test "create with invalid type" do
    assert_no_difference -> { @user.songsheets.count } do
      post api_library_path, params: {uid: @user.uid},
        headers: token_headers(@user)
    end

    assert_response 422
  end

  test "create with non-existent record" do
    assert_no_difference -> { @user.songsheets.count } do
      post api_library_path, params: {uid: Songsheet.new(id: -1).uid},
        headers: token_headers(@user)
    end

    assert_response 422
  end

  test "show" do
    songsheet = create(:songsheet)
    @user.songsheets << songsheet

    get api_library_path, params: {uid: songsheet.uid},
      headers: token_headers(@user)
    assert_response :success

    assert_raises ActiveRecord::RecordNotFound do
      get api_library_path, params: {uid: create(:songsheet).uid},
        headers: token_headers(@user)
    end
  end

  test "destroy" do
    songsheet = create(:songsheet)
    @user.songsheets << songsheet

    delete api_library_path, params: {uid: songsheet.uid},
      headers: token_headers(@user)
    assert_response :success
  end
end