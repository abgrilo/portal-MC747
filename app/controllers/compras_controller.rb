class ComprasController < ApplicationController
  # GET /compras
  # GET /compras.xml
  def index
  end

  #TODO serviço
  def tem_produto_no_estoque(id_produto)
    return true
  end

  #Edilson
  def consulta_credito_cliente (cpf)
    client = Savon::Client.new do
      wsdl.document = "http://www.supercontrole.com/747/wsConsultaCliente.asmx?WSDL"
    end
    resp = client.request :wsdl, :consulta_cliente do
      soap.body = {:token => "TESTE", :cpf => cpf}
    end
    resp.to_hash[:consulta_cliente_response][:consulta_cliente_result] == "0"
  end
    
  # GET /compras/new
  # GET /compras/new.xml
  def new
    id_produto = params[:produto]
    
    if not tem_produto_no_estoque(id_produto)
      render :produto_indisponivel
      return
    end
    
    @preco_produto = 1.0
    @compra = Compra.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @compra }
    end
  end

  # GET /compras/1/edit
  def edit
    @compra = Compra.find(params[:id])
  end

  # POST /compras
  # POST /compras.xml
  def create
    preco_produto = params[:preco_produto]
    @compra = Compra.new(params[:compra])

     #TODO verificar crédito
    if consulta_credito_cliente(session[:user].cpf)
      redirect_to new_endereco_path
    else
      render :sem_credito      
    end

  end

end
