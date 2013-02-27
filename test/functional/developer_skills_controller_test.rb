require 'test_helper'

class DeveloperSkillsControllerTest < ActionController::TestCase
  setup do
    @developer_skill = developer_skills(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:developer_skills)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create developer_skill" do
    assert_difference('DeveloperSkill.count') do
      post :create, developer_skill: { employee_id: @developer_skill.employee_id, proficiency: @developer_skill.proficiency, skill_id: @developer_skill.skill_id }
    end

    assert_redirected_to developer_skill_path(assigns(:developer_skill))
  end

  test "should show developer_skill" do
    get :show, id: @developer_skill
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @developer_skill
    assert_response :success
  end

  test "should update developer_skill" do
    put :update, id: @developer_skill, developer_skill: { employee_id: @developer_skill.employee_id, proficiency: @developer_skill.proficiency, skill_id: @developer_skill.skill_id }
    assert_redirected_to developer_skill_path(assigns(:developer_skill))
  end

  test "should destroy developer_skill" do
    assert_difference('DeveloperSkill.count', -1) do
      delete :destroy, id: @developer_skill
    end

    assert_redirected_to developer_skills_path
  end
end
