require 'test_helper'

class DeliveriesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Delivery.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Delivery.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Delivery.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to delivery_url(assigns(:delivery))
  end
  
  def test_edit
    get :edit, :id => Delivery.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Delivery.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Delivery.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Delivery.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Delivery.first
    assert_redirected_to delivery_url(assigns(:delivery))
  end
  
  def test_destroy
    delivery = Delivery.first
    delete :destroy, :id => delivery
    assert_redirected_to deliveries_url
    assert !Delivery.exists?(delivery.id)
  end
end
