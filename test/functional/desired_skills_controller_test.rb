require 'test_helper'

class DesiredSkillsControllerTest < ActionController::TestCase
  setup do
    @desired_skill = desired_skills(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:desired_skills)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create desired_skill" do
    assert_difference('DesiredSkill.count') do
      post :create, desired_skill: { employee_id: @desired_skill.employee_id, interest: @desired_skill.interest, skill_id: @desired_skill.skill_id }
    end

    assert_redirected_to desired_skill_path(assigns(:desired_skill))
  end

  test "should show desired_skill" do
    get :show, id: @desired_skill
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @desired_skill
    assert_response :success
  end

  test "should update desired_skill" do
    put :update, id: @desired_skill, desired_skill: { employee_id: @desired_skill.employee_id, interest: @desired_skill.interest, skill_id: @desired_skill.skill_id }
    assert_redirected_to desired_skill_path(assigns(:desired_skill))
  end

  test "should destroy desired_skill" do
    assert_difference('DesiredSkill.count', -1) do
      delete :destroy, id: @desired_skill
    end

    assert_redirected_to desired_skills_path
  end
end
