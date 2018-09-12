require Rails.root.join('plugins', 'easyproject', 'easy_plugins', 'easy_extensions/test/spec/spec_helper')

describe ESCOJIDALaEntidasController, logged: true do
  let(:escojida_la_entida) { FactoryGirl.create(:escojida_la_entida) }
  let(:escojida_la_entidas) { FactoryGirl.create_list(:escojida_la_entida, 5) }

  before(:each) do
    role = Role.non_member
    role.add_permission! :view_escojida_la_entidas
    role.add_permission! :manage_escojida_la_entidas
  end

  render_views

  it 'index' do
    escojida_la_entidas

    get :index
    expect(response).to have_http_status(:success)
    expect(response).to render_template('escojida_la_entidas/index')
  end

  it 'show' do
    get :show, {id: escojida_la_entida}
    expect(response).to have_http_status(:success)
    expect(response).to render_template('escojida_la_entidas/show')
  end

  it 'new' do
    get :new
    expect(response).to have_http_status(:success)
    expect(response).to render_template('escojida_la_entidas/new')
  end

  it 'create with invalid' do
    post :create, {escojida_la_entida: {}}
    expect(response).to have_http_status(:success)
    expect(assigns[:escojida_la_entida]).to be_a_new(ESCOJIDALaEntida)
    expect(response).to render_template('escojida_la_entidas/new')
  end

  it 'create with valid' do
    post :create, {escojida_la_entida: FactoryGirl.attributes_for(:escojida_la_entida)}
    expect(response).to have_http_status(:success)
    expect(assigns[:escojida_la_entida]).not_to be_a_new(ESCOJIDALaEntida)
    expect(response).to redirect_to(escojida_la_entida_path(assigns[:escojida_la_entida]))
  end

  it 'edit' do
    get :edit, {id: escojida_la_entida}
    expect(response).to have_http_status(:success)
    expect(response).to render_template('escojida_la_entidas/edit')
  end

  it 'update with invalid' do
    put :update, {id: escojida_la_entida, escojida_la_entida: {["name", {:type=>"string", :idx=>nil, :null=>true, :safe=>true, :query_type=>"string", :lang_key=>"name"}]: ''}}
    expect(response).to have_http_status(:success)
    expect(assigns[:escojida_la_entida].valid?).to be false
    expect(response).to render_template('escojida_la_entidas/edit')
  end

  it 'update with valid' do
    put :update, {id: escojida_la_entida, escojida_la_entida: {["name", {:type=>"string", :idx=>nil, :null=>true, :safe=>true, :query_type=>"string", :lang_key=>"name"}]: 'Tralalala'}}
    expect(response).to have_http_status(:success)
    expect(assigns[:escojida_la_entida].valid?).to be true
    expect(response).to redirect_to(escojida_la_entida_path(assigns[:escojida_la_entida]))
  end

  it 'destroy' do
    escojida_la_entida
    escojida_la_entidas

    expect(ESCOJIDALaEntida.count).to eq(6)
    expect {delete :destroy, {id: escojida_la_entida}}.to change(ESCOJIDALaEntida, :count).by(-1)
    expect(response).to redirect_to(escojida_la_entidas_path)
    expect(response).to redirect_to(escojida_la_entidas_path)
  end
end
