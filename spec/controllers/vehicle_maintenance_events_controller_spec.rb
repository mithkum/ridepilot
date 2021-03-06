require "rails_helper"

RSpec.describe VehicleMaintenanceEventsController, type: :controller do
  login_admin_as_current_user
  
  before(:each) do
    @vehicle = create(:vehicle)
  end

  # This should return the minimal set of attributes required to create a valid
  # VehicleMaintenanceEvent. As you add validations to VehicleMaintenanceEvent, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { 
    # Nothing is required according to the model, but adding driver_id to 
    # satisfy non-null constraint in DB
    attributes_for(:vehicle_maintenance_event, :vehicle_id => @vehicle.id)
  }

  let(:invalid_attributes) { 
    # Nothing is required, and the model has no validations
  }

  describe "GET #index" do
    it "redirects to the current user's provider" do
      get :index, {}
      expect(response).to redirect_to(@current_user.current_provider)
    end
  end

  describe "GET #new" do
    it "assigns a new vehicle_maintenance_event as @vehicle_maintenance_event" do
      get :new, {}
      expect(assigns(:vehicle_maintenance_event)).to be_a_new(VehicleMaintenanceEvent)
    end

    it "assigns the requested vehicle_id" do
      get :new, {:vehicle_id => 1}
      expect(assigns(:vehicle_maintenance_event).vehicle_id).to eq(1)
    end
  end

  describe "GET #edit" do
    it "assigns the requested vehicle_maintenance_event as @vehicle_maintenance_event" do
      vehicle_maintenance_event = create(:vehicle_maintenance_event, :provider => @current_user.current_provider)
      get :edit, {:id => vehicle_maintenance_event.to_param}
      expect(assigns(:vehicle_maintenance_event)).to eq(vehicle_maintenance_event)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new VehicleMaintenanceEvent" do
        expect {
          post :create, {:vehicle_maintenance_event => valid_attributes}
        }.to change(VehicleMaintenanceEvent, :count).by(1)
      end

      it "assigns a newly created vehicle_maintenance_event as @vehicle_maintenance_event" do
        post :create, {:vehicle_maintenance_event => valid_attributes}
        expect(assigns(:vehicle_maintenance_event)).to be_a(VehicleMaintenanceEvent)
        expect(assigns(:vehicle_maintenance_event)).to be_persisted
      end

      it "redirects to the vehicle record" do
        post :create, {:vehicle_maintenance_event => valid_attributes}
        expect(response).to redirect_to(VehicleMaintenanceEvent.last.vehicle)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved vehicle_maintenance_event as @vehicle_maintenance_event" do
        skip("Nothing is required, and the model has no validations")
        post :create, {:vehicle_maintenance_event => invalid_attributes}
        expect(assigns(:vehicle_maintenance_event)).to be_a_new(VehicleMaintenanceEvent)
      end

      it "re-renders the 'new' template" do
        skip("Nothing is required, and the model has no validations")
        post :create, {:vehicle_maintenance_event => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { {
        :vehicle_id =>  @vehicle.id,
        :reimbursable =>  false,
        :service_date =>  "2015-02-20 00:00:00",
        :invoice_date =>  "2015-02-20 00:00:00",
        :services_performed =>  "MyText",
        :odometer =>  9.99,
        :vendor_name =>  "MyString",
        :invoice_number =>  "MyString",
        :invoice_amount =>  9.99
      } }

      it "updates the requested vehicle_maintenance_event" do
        vehicle_maintenance_event = create(:vehicle_maintenance_event, :provider => @current_user.current_provider)
        expect {
          put :update, {:id => vehicle_maintenance_event.to_param, :vehicle_maintenance_event => new_attributes}
        }.to change { vehicle_maintenance_event.reload.invoice_amount }.from(nil).to(9.99)
      end

      it "assigns the requested vehicle_maintenance_event as @vehicle_maintenance_event" do
        vehicle_maintenance_event = create(:vehicle_maintenance_event, :provider => @current_user.current_provider)
        put :update, {:id => vehicle_maintenance_event.to_param, :vehicle_maintenance_event => new_attributes}
        expect(assigns(:vehicle_maintenance_event)).to eq(vehicle_maintenance_event)
      end

      it "redirects to the vehicle record" do
        vehicle_maintenance_event = create(:vehicle_maintenance_event, :provider => @current_user.current_provider)
        put :update, {:id => vehicle_maintenance_event.to_param, :vehicle_maintenance_event => new_attributes}
        expect(response).to redirect_to(VehicleMaintenanceEvent.last.vehicle)
      end
    end

    context "with invalid params" do
      it "assigns the vehicle_maintenance_event as @vehicle_maintenance_event" do
        skip("Nothing is required, and the model has no validations")
        vehicle_maintenance_event = create(:vehicle_maintenance_event, :provider => @current_user.current_provider)
        put :update, {:id => vehicle_maintenance_event.to_param, :vehicle_maintenance_event => invalid_attributes}
        expect(assigns(:vehicle_maintenance_event)).to eq(vehicle_maintenance_event)
      end

      it "re-renders the 'edit' template" do
        skip("Nothing is required, and the model has no validations")
        vehicle_maintenance_event = create(:vehicle_maintenance_event, :provider => @current_user.current_provider)
        put :update, {:id => vehicle_maintenance_event.to_param, :vehicle_maintenance_event => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

end
