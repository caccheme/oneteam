require 'test_helper'

class RequestSkillsControllerTest < ActionController::TestCase
  setup do
    @request_skill = request_skills(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:request_skills)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create request_skill" do
    assert_difference('RequestSkill.count') do
      post :create, request_skill: { request_id: @request_skill.request_id, skill_id: @request_skill.skill_id }
    end

    assert_redirected_to request_skill_path(assigns(:request_skill))
  end

  test "should show request_skill" do
    get :show, id: @request_skill
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @request_skill
    assert_response :success
  end

  test "should update request_skill" do
    put :update, id: @request_skill, request_skill: { request_id: @request_skill.request_id, skill_id: @request_skill.skill_id }
    assert_redirected_to request_skill_path(assigns(:request_skill))
  end

  test "should destroy request_skill" do
    assert_difference('RequestSkill.count', -1) do
      delete :destroy, id: @request_skill
    end

    assert_redirected_to request_skills_path
  end
end
