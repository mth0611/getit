require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "controller source data test" do
    UserSession.create(users(:std5))
    assert_nil(@controller.adm_library_code)
    assert_nil(@controller.sub_library_code)
    assert_nil(@controller.source_record_id)
    assert_nil(@controller.item_id)
    assert_nil(@controller.item_status_code)
    assert_nil(@controller.item_process_status_code)
    assert_nil(@controller.circulation_status)
    assert_nil(@controller.illiad_url)
    assert_nil(@controller.aleph_rest_url)
    assert_nil(@controller.ill_url)
    assert_nil(@controller.scan?)
    assert_nil(@controller.pickup_location)
    assert_nil(@controller.request_type)
    get(:new, {'service_response_id' => "1"})
    assert_response :success
    assert_equal("NYU50", @controller.adm_library_code)
    assert_equal("BOBST", @controller.sub_library_code)
    assert_equal("000980206", @controller.source_record_id)
    assert_equal("NYU50000980206000010", @controller.item_id)
    assert_equal("01", @controller.item_status_code)
    assert_nil(@controller.item_process_status_code)
    assert_equal("On Shelf", @controller.circulation_status)
    assert_equal("http://ill.library.nyu.edu", @controller.illiad_url)
    assert_equal("http://aleph.library.nyu.edu:1891/rest-dlf", @controller.aleph_rest_url)
    assert((not @controller.ill_url.nil?))
    assert_nil(@controller.scan?)
    assert_nil(@controller.pickup_location)
    assert_nil(@controller.request_type)
  end

  test "request types" do
    assert_equal(["available", "ill", "in_processing", "offsite", "on_order", "recall"], 
      @controller.request_types)
  end

  test "request attributes" do
    assert_equal([:status, :status_code, :adm_library_code, :sub_library, :sub_library_code, 
      :source_record_id, :item_id, :item_status_code, :item_process_status_code, 
        :circulation_status], @controller.send(:request_attributes))
  end

  test "item permissions" do
    get(:new, {'service_response_id' => "1"})
    @controller.send(:init)
    assert((not @controller.send(:item_permissions).nil?))
    assert((not @controller.send(:item_permissions).empty?))
  end

  test "item requestability" do
    get(:new, {'service_response_id' => "1"})
    @controller.send(:init)
    assert_equal(RequestsHelper::RequestableDeferred, @controller.send(:item_requestability))
  end

  test "item requestable" do
    get(:new, {'service_response_id' => "1"})
    @controller.send(:init)
    assert(@controller.send(:item_requestable?))
  end

  test "user permissions" do
    UserSession.create(users(:std5))
    get(:new, {'service_response_id' => "1"})
    assert((not @controller.send(:user_permissions).nil?))
    assert((not @controller.send(:user_permissions).empty?))
  end

  test "request" do
    UserSession.create(users(:std5))
    get(:new, {'service_response_id' => "1"})
    assert @controller.request?, "Not requestable."
  end

  test "request available" do
    UserSession.create(users(:std5))
    get(:new, {'service_response_id' => "1"})
    assert @controller.request_available?, "Not requestable available."
    assert((not @controller.request_recall?), "Recall requestable.")
    assert((not @controller.request_in_processing?), "In processing requestable.")
    assert((not @controller.request_on_order?), "On order requestable.")
    assert((not @controller.request_offsite?), "Offsite requestable.")
    assert((not @controller.request_ill?), "ILL requestable.")
  end

  test "no logged in user" do
    get(:new, {'service_response_id' => "1"})
    assert_response :redirect
    assert_redirected_to "http://test.host/login?service_response_id=1"
  end

  test "new available" do
    UserSession.create(users(:std5))
    get(:new, {'service_response_id' => "1"})
    assert_response :success
    assert_select 'div.request' do |elements|
      assert_select 'h2', {:count => 1, 
        :text => "Virtual inequality : beyond the digital divide is available at NYU Bobst."}, 
          "Unexpected h2 text."
      assert_select 'ol.request_options li', 2
    end
  end
end