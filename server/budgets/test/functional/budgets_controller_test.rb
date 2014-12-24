require 'test_helper'

class BudgetsControllerTest < ActionController::TestCase
  
  test "index via API should return assignments" do
    get :index, :format => "xml"
    
    assert_response :success
    xml = Hash.from_xml(@response.body)
    assert_equal 3, xml["assignments"].length
  end
  
  test "show via API should return assignment record" do
    get :show, :id => assignments(:ds10).to_param, :format => "xml"
    assert_response :success
    xml = Hash.from_xml(@response.body)
    assert_equal assignments(:ds10).id, xml["assignment"]["id"]
  end
  
  test "new via API should return a template XML response" do
    login_admin
    get :new, :format => "xml"
    assert_response :success
    xml = Hash.from_xml(@response.body)
    assert xml["assignment"]
    assert !xml["assignment"]["id"]
  end
  
  test "create via API should return 422 with error messages when validations fail" do
    login_admin
    post :create, :assignment => { }, :format => "xml"
    assert_response :unprocessable_entity
    xml = Hash.from_xml(@response.body)
    assert xml["errors"].any?
  end
  
  test "create via API should create assignment and respond with 201" do
    login_admin
    assert_difference "Assignment.count" do
      post :create,
           :assignment => {:text => "Text", :tag => "tag", :date => Time.now},
           :format => "xml"
      assert_response :created
      assert @response.headers["Location"]
    end
  end
  
  test "update via API with validation errors should respond with 422" do
    login_admin
    put :update, :id => assignments(:ds10).to_param, 
                 :assignment => { :text => "" }, 
                 :format => "xml"
    assert_response :unprocessable_entity
    xml = Hash.from_xml(@response.body)
    assert xml["errors"].any?
  end

  test "update via API should update assignment and respond with 200" do
    login_admin
    put :update, :id => assignments(:ds10).to_param, 
                 :assignment => { :text => "new text" }, 
                 :format => "xml"
    assert_response :success  
    xml = Hash.from_xml(@response.body)    
    assert_equal "new text", xml["assignment"]["text"]
  end

  test "destroy via API should remove assignment and respond with 200" do
    login_admin
    assert_difference "Assignment.count", -1 do
      delete :destroy, :id => assignments(:ds10).to_param, :format => "xml"
      assert_response :success
    end
  end
  
end
