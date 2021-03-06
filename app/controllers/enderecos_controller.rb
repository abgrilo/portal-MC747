class EnderecosController < ApplicationController
  # GET /enderecos
  # GET /enderecos.xml
  def index
    @enderecos = Endereco.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @enderecos }
    end
  end

  # GET /enderecos/1
  # GET /enderecos/1.xml
  def show
    @endereco = Endereco.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @endereco }
    end
  end

  # GET /enderecos/new
  # GET /enderecos/new.xml
  def new
    @endereco = Endereco.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @endereco }
    end
  end

  # GET /enderecos/1/edit
  def edit
    @endereco = Endereco.find(params[:id])
  end

  def get_endereco(cep)
    client = Savon::Client.new do
      wsdl.document = "http://localhost:8085/axis2/services/EnderecosService?wsdl" 
    end
    resp= client.request :wsdl, :getEndereco do
      soap.body = {:cep => cep}
    end
    r = resp.to_hash[:get_endereco_response][:return]
    if r[:logradouro] == "-1"
      return nil
    end
    return r
  end  

  def manda_email()
    client = Savon::Client.new do
      wsdl.document = "http://localhost:3001/hello_message/wsdl"
    end
    
    h = SequencedHash.new
    h[:token] = "1"
    h[:destinatarios] = "dnalves3@gmail.com"
    h[:template_id] = "1"
    h[:fields] = "abc,123"

    client.request :wsdl, :hello_message do 
      soap.body = h
     end
  end

  # POST /enderecos
  # POST /enderecos.xml
  def create
    @endereco = Endereco.new(params[:endereco])

    respond_to do |format|
      @resp_endereco = get_endereco(@endereco.cep)
      if @resp_endereco.blank?
        format.html do
          render :endereco_invalido
        end
      end
      if @endereco.save
        manda_email
        format.html
        format.xml  { render :xml => @endereco, :status => :created, :location => @endereco }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @endereco.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /enderecos/1
  # PUT /enderecos/1.xml
  def update
    @endereco = Endereco.find(params[:id])

    respond_to do |format|
      if @endereco.update_attributes(params[:endereco])
        format.html { redirect_to(@endereco, :notice => 'Endereco was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @endereco.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /enderecos/1
  # DELETE /enderecos/1.xml
  def destroy
    @endereco = Endereco.find(params[:id])
    @endereco.destroy

    respond_to do |format|
      format.html { redirect_to(enderecos_url) }
      format.xml  { head :ok }
    end
  end
end
