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

  # POST /enderecos
  # POST /enderecos.xml
  def create
    @endereco = Endereco.new(params[:endereco])

    respond_to do |format|
      if @endereco.save
        format.html { redirect_to(@endereco, :notice => 'Endereco was successfully created.') }
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
