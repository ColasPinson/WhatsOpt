# frozen_string_literal: true

require "test_helper"

class OptimizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:user1)
    @ack = optimizations(:optim_ackley2d)
    @unstat = optimizations(:optim_unkown_status)
  end

  test "should get index" do
    get optimizations_url
    assert_response :success
    assert_select "tbody>tr", count: Optimization.owned_by(users(:user1)).size
  end

  test "admin should destroy optimization" do
    sign_out users(:user1)
    sign_in users(:admin)
    assert_difference("Optimization.count", -1) do
      delete destroy_selected_optimizations_path, params: { optimization_request_ids: [@ack.id] }
      assert_redirected_to optimizations_url
    end
  end

  test "non-owner cannot destroy optimization" do
    assert_difference("Optimization.count", 0) do
      delete destroy_selected_optimizations_path, params: { optimization_request_ids: [@unstat.id] }
    end
  end

  test "download should send file properly" do
    get optimization_download_path(@ack.id)
    assert_response :success
    assert_equal controller.headers["Content-Transfer-Encoding"], "binary"
  end

  test "should get new" do
    get new_optimization_url
    assert_response :success
  end

  test "should create pending optimization" do
    assert_difference("Optimization.count") do
      post optimizations_url, params: { optimization: { kind: "SEGOMOE", xlimits: "[[1, 2], [3, 4]]" } }
    end
    assert_equal Optimization.last.outputs["status"], -1
    assert_redirected_to optimizations_url
  end

  test "should assign owner on creation" do
    post optimizations_url, params: { optimization: { kind: "SEGOMOE", xlimits: "[[1, 2], [3, 4]]" } }
    assert Optimization.last.owner, users(:user1)
  end

  test "should authorized access by default" do
    post optimizations_url, params: { optimization: { kind: "SEGOMOE", xlimits: "[[1, 2], [3, 4]]" } }
    sign_out users(:user1)
    sign_in users(:user2)
    get optimization_url(Optimization.last)
    assert_response :found
  end
end
